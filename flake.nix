{
  description = "RoFI bots";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Robot Operating System overlay (contains gazebo).
    ros = {
      url = "github:lopsided98/nix-ros-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, nixpkgs, ros, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        # Get Nixpkgs packages for the current platform.
        pkgs = import nixpkgs {
          inherit system;
          config = { };
          overlays = [
            ros.overlay

            (final: prev: {
              # Stable versions of tbb (a gazebo dependency) do not provide a pkg-config file.
              # And while gazebo’s build system can still find the library without .pc file and
              # successfully link against it, it will not propagate the necessary flags
              # in the .pc file. This will result in simplesim not being able to find tbb header:
              #
              #     In file included from /nix/store/…-gazebo-11.3.0/include/gazebo-11/gazebo/Master.hh:28,
              #                      from …/RoFI/softwareComponents/simplesim/gazebo_master/gazebo_master.hpp:6,
              #                      from …/RoFI/softwareComponents/simplesim/gazebo_master/gazebo_master.cpp:1:
              #     /nix/store/…-gazebo-11.3.0/include/gazebo-11/gazebo/transport/Connection.hh:20:10: fatal error: tbb/task.h: No such file or directory
              #        20 | #include <tbb/task.h>
              #           |          ^~~~~~~~~~~~
              #
              # This issue does not occur on Debian because it ships custom `tbb.pc` file[1]
              # so `gazebo.pc` will include `tbb` in `Requires` field[2] there.
              # It will also not happen on Arch Linux because tbb headers are installed
              # to the standard header location (/usr/include) so they are accidentally found
              # through `-I` flag of some other library.
              #
              # This issue gets revealed on NixOS, which ships minimally modified packages (like Arch)
              # and installs headers of each package into a different prefix.
              #
              # This should be fixed in an upcoming tbb release since it will have an upstream pkg-config file[3].
              # I have also opened a pull request incorporating this change into Nixpkgs[4].
              #
              # [1]: https://salsa.debian.org/science-team/tbb/-/blob/4c31cbb2fa413f099cb4207beb10757dc2f41674/debian/tbb.pc.in
              # [2]: https://github.com/osrf/gazebo/commit/417514735dbc03d6357bd57e9f2f59d4198544a2#diff-070f9711d42593f839e9cb29c2bcb31f999939af11125c208965891a2ba1617c
              # [3]: https://github.com/oneapi-src/oneTBB/tree/6aa706d879bebf3873a4b94a4b1a27aac4f844e8/integration/pkg-config
              # [4]: https://github.com/NixOS/nixpkgs/pull/122587
              tbb = prev.tbb.overrideAttrs (attrs: {
                postInstall = let
                  pcTemplate = pkgs.fetchurl {
                    url = "https://github.com/oneapi-src/oneTBB/raw/master/integration/pkg-config/tbb.pc.in";
                    sha256 = "2pCad9txSpNbzac0vp/VY3x7HNySaYkbH3Rx8LK53pI=";
                  };
                in attrs.postInstall or "" + ''
                  # Generate pkg-config file based on upstream template.
                  # It should not be necessary with tbb after 2021.2.
                  mkdir -p "$out/lib/pkgconfig"
                  substitute "${pcTemplate}" "$out/lib/pkgconfig/tbb.pc" \
                    --subst-var-by CMAKE_INSTALL_PREFIX "$out" \
                    --subst-var-by CMAKE_INSTALL_LIBDIR "lib" \
                    --subst-var-by CMAKE_INSTALL_INCLUDEDIR "include" \
                    --subst-var-by TBB_VERSION "${attrs.version}" \
                    --subst-var-by TBB_LIB_NAME "tbb"
                '';
              });

              vtk7WithQt =
                (prev.vtk_7.override {
                  enableQt = true;
                }).overrideAttrs (attrs: {
                  cmakeFlags = attrs.cmakeFlags or [] ++ [
                    "-DVTK_QT_VERSION=5"
                  ];

                  patches = attrs.patches or [] ++ [
                    # Add missing include required with recent Qt.
                    (prev.fetchpatch {
                      url = "https://gitlab.kitware.com/vtk/vtk/-/commit/797f28697d5ba50c1fa2bc5596af626a3c277826.diff";
                      sha256 = "BFjoKws1hVD3Ly9RS4lGN62J6RTyI1E8ATHrZdzg7ds=";
                    })
                  ];
                });

              vtk8WithQt = prev.vtk_8.override { enableQt = true; };

              vtk9WithQt = (prev.vtk_9.override {
                enableQt = true;
              }).overrideAttrs (attrs: {
                cmakeFlags =
                  let
                    replacements = {
                      "-DVTK_USE_SYSTEM_PNG=ON" = "-DVTK_MODULE_USE_EXTERNAL_vtkpng=ON";
                      "-DVTK_USE_SYSTEM_TIFF=1" = "-DVTK_MODULE_USE_EXTERNAL_vtktiff=1";
                      "-DVTK_Group_Qt:BOOL=ON" = "-DVTK_GROUP_ENABLE_Qt:STRING=YES";
                    };
                  in
                  builtins.map (flag: replacements.${builtins.unsafeDiscardStringContext flag} or flag) (attrs.cmakeFlags or []);
              });
            })
          ];
        };

        pythonForDocs = pkgs.python3.withPackages (pp: with pp; [
          breathe
          recommonmark
          sphinx
          sphinx_rtd_theme
        ]);

        mkDevShell =
          { vtk }:
          pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              cmake

              # For FetchContent CMake macro.
              git

              # For docs.
              doxygen
              graphviz
              pythonForDocs

              # For setting Qt environment variables.
              qt5.wrapQtAppsHook
              makeWrapper
            ];

            buildInputs = with pkgs; [
              gazebo
              protobuf
              vtk
              qt5.qtbase
              armadillo
              z3

              # For rofi-vis-video.
              inkscape
              ffmpeg
            ];

            # TLS certificates so that git can clone GitHub repos.
            GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

            shellHook = ''
              # Add Qt-related environment variables.
              # https://discourse.nixos.org/t/python-qt-woes/11808/10
              setQtEnvironment=$(mktemp)
              random=$(openssl rand -base64 20 | sed "s/[^a-zA-Z0-9]//g")
              makeWrapper "$(type -p sh)" "$setQtEnvironment" "''${qtWrapperArgs[@]}" --argv0 "$random"
              sed "/$random/d" -i "$setQtEnvironment"
              source "$setQtEnvironment"

              source ./setup.sh -f Debug
            '';
          };
      in {
        # Expose packages for debugging purposes.
        packages = pkgs;

        # Provides shell environment for development.
        devShell = self.devShells.${system}.vtk7;

        devShells = {
          vtk7 = mkDevShell {
            vtk = pkgs.vtk7WithQt;
          };
          vtk8 = mkDevShell {
            vtk = pkgs.vtk8WithQt;
          };
          vtk9 = mkDevShell {
            vtk = pkgs.vtk9WithQt;
          };
        };
      }
    );
}
