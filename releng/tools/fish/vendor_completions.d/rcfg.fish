function _external_completion
    # Get the current command up to a cursor.
    # - Behaves correctly even with pipes and nested in commands like env.
    # - Note that it returns the command verbatim (does not interpolate variables).
    set -l fixed_args (commandline --current-process --tokenize --cut-at-cursor)
    # --cut-at-cursor with --tokenize removes the current token so we need to add it separately.
    # https://github.com/fish-shell/fish-shell/issues/7375
    # Can be an empty string.
    set -l current_token (commandline --current-token --cut-at-cursor)

    # The completion scripts also want the index of the argv item to complete
    # but the $fixed_args variable contains the program name (argv[0]) so we would need to subtract 1.
    # But the variable also misses the current token so it cancels out.
    set -l arg_to_complete (count $fixed_args)

    env $ROFI_ROOT/releng/tools/$argv[1] $arg_to_complete $fixed_args $current_token
end

function _rcfg_completion
    _external_completion _rcfg.completion.py $arguments
end

function _rmake_completion
    _external_completion _rmake.completion.py $arguments
end

set util (basename (status filename) .fish)
complete --path $ROFI_ROOT/releng/tools/$util --no-files --arguments '(_'$util'_completion)'
