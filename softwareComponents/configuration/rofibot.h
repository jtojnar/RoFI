#pragma once

#include <memory>
#include <vector>
#include <set>

#include <atoms/containers.hpp>
#include <atoms/algorithm.hpp>
#include <tcb/span.hpp>
#include <fmt/format.h>

#include "joints.h"
#include "Matrix.h"

namespace rofi {

/// ModuleId
using ModuleId = int;

enum class ComponentType {
    UmShoe, UmBody,
    Roficom
};

enum class ModuleType {
    Unknown,
    Universal,
    Cube,
};

enum class Orientation { North, East, South, West };

/**
 * \brief Joint between two components of the same module
 */
struct ComponentJoint {
    ComponentJoint( std::unique_ptr< Joint > joint, int source, int dest ):
        joint( std::move( joint ) ),
        sourceComponent( source ),
        destinationComponent( dest )
    {}

    atoms::ValuePtr< Joint > joint;
    int sourceComponent, destinationComponent;
};

template< typename JointT, typename...Args >
ComponentJoint makeJoint( int source, int dest, Args&&...args ) {
    return ComponentJoint{
        std::make_unique< JointT >( ( std::forward< Args >( args ) )... ),
        source, dest };
}

/**
 * \brief Joint between two modules.
 *
 * The joint is created between two components of two modules specified by
 * module ids and corresponding component index.
 */
struct RoficomJoint: public Joint {
    RoficomJoint( Orientation o, ModuleId sourceModule, ModuleId destModule,
        int sourceConnector, int destConnector)
    : orientation( o ), sourceModule( sourceModule ), destModule( destModule ),
      sourceConnector( sourceConnector ), destConnector( destConnector )
    {}

    int paramCount() const override {
        return 0;
    }

    Matrix sourceToDest() const override {
        assert( positions.size() == 0 );
        return identity; // ToDo: Implement
    }

    std::pair< double, double > jointLimits( int ) const override {
        throw std::logic_error( "RoFICoM joint has no parameters" );
    }

    ATOMS_CLONEABLE( RoficomJoint );

    Orientation orientation;
    ModuleId sourceModule;
    ModuleId destModule;
    int sourceConnector;
    int destConnector;
};

/**
 * \brief Joint between a fixed point in space and a module
 */
struct SpaceJoint {
    atoms::ValuePtr< Joint > joint;
    const Vector refPoint;
    const ModuleId destModule;
    const int destComponent;
};

class Rofibot;
class Module;

/**
 * \brief Single body of a module
 */
struct Component {
    ComponentType type;
    std::vector< int > inJoints;
    std::vector< int > outJoints;

    Module *parent;

    bool operator==( const Component& o ) const {
        return type == o.type &&
               inJoints == o.inJoints &&
               outJoints == o.outJoints &&
               parent == o.parent;
    }

    bool operator!=( const Component& o ) const {
        return !( *this == o );
    }
};

/**
 * \brief RoFI module
 *
 * The module is composed out of components.
 */
class Module {
public:
    /**
     * \brief Construct module
     *
     * Note that components contain all module components out of which first \p
     * connectorCount are module connectors.
     *
     * The user can optionally specify a root component (e.g, in case of cyclic
     * joints). If no root component is specified, component with no ingoing
     * joints is selected.
     */
    Module( ModuleType type,
        std::vector< Component > components,
        int connectorCount,
        std::vector< ComponentJoint > joints,
        int rootComponent = -1 )
    : type( type ),
      _components( std::move( components ) ),
      _connectorCount( connectorCount ),
      _joints( std::move( joints ) ),
      parent( nullptr ),
      _rootComponent( rootComponent )
    {
        _prepareComponents();
        if ( _rootComponent == -1 )
            _rootComponent = _computeRoot();
    }

    Module( const Module& o ):
        id( o.id ),
        type( o.type ),
        parent( o.parent ),
        _components( o._components ),
        _connectorCount( o._connectorCount ),
        _joints( o._joints ),
        _rootComponent( o._rootComponent ),
        _componentPosition( o._componentPosition )
    {}

    Module& operator=( Module o ) {
        swap( o );
        return *this;
    }

    void swap( Module& o ) {
        using std::swap;
        swap( id, o.id );
        swap( type, o.type );
        swap( parent, o.parent );
        swap( _components, o._components );
        swap( _connectorCount, o._connectorCount );
        swap( _joints, o._joints );
        swap( _componentPosition, o._componentPosition );
    }

    void setJointParams( int idx, const Joint::Positions& p );
    // Implemented in CPP files as it depends on definition of Rofibot

    /**
     * \brief Get a component position relative to module origin
     *
     * Raises std::logic_error if the components are inconsistent
     */
    Matrix getComponentPosition( int idx ) {
        assert( idx < _components.size() );
        if ( !_componentPosition )
            prepare();
        return _componentPosition.value()[ idx ];
    }

    /**
     * \brief Get a component position within coordinate system specified by the
     * second argument.
     *
     * Raises std::logic_error if the components are inconsistent
     */
    Matrix getComponentPosition( int idx, Matrix position ) {
        return position * _componentPosition.value()[ idx ];
    }

    /**
     * \brief Precompute component positions
     *
     * Raises std::logic_error if the components are inconsistent
     */
    void prepare() {
        std::vector< Matrix > positions( _components.size() );
        std::vector< bool > initialized( _components.size() );

        auto dfsTraverse = [&]( int compIdx, Matrix position, auto& self ) {
            if ( initialized[ compIdx ] ) {
                if ( !equals( position, positions[ compIdx ] ) )
                    throw std::logic_error( "Inconsistent component positions" );
                return;
            }
            positions[ compIdx ] = position;
            initialized[ compIdx ] = true;
            for ( int outJointIdx : _components[ compIdx ].outJoints ) {
                const ComponentJoint& j = _joints[ outJointIdx ];
                self( j.destinationComponent, j.joint->sourceToDest() * position, self );
            }
        };
        dfsTraverse( _rootComponent, identity, dfsTraverse );

        if ( !atoms::all( initialized ) )
            throw std::logic_error( "There are components without position" );
    }

    /**
     * \brief Get read-only view of the components
     */
    tcb::span< const Component > components() const {
        return _components;
    }

    const Component& component( int idx ) {
        return components()[ idx ];
    }

    /**
     * \brief Get read-only view of the bodies
     */
    tcb::span< const Component > bodies() {
        return { &_components[ _connectorCount ], &_components.back() };
    }

    const Component& body( int idx ) {
        return bodies()[ idx ];
    }

    /**
     * \brief Get read-only view of the connectors
     */
    tcb::span< const Component > connectors() {
        return { &_components.front(), size_t( _connectorCount ) };
    };

    const Component& connector( int idx ) {
        return connectors()[ idx ];
    }

    /**
     * \brief Get index of a component
     */
    int componentIdx( const Component& c ) {
        int idx = 0;
        for ( const rofi::Component& x : _components ) {
            if ( x == c )
                return idx;
            idx++;
        }
        throw std::logic_error( "Component does not belong to the module" );
    }

    Module *clone() const {
        return new Module( *this );
    }

    ModuleId id; ///< integral identifier unique within a context of a single rofibot
    ModuleType type; ///< module type
    Rofibot* parent; ///< pointer to parenting Rofibot
private:
    std::vector< Component > _components; ///< All module components, first _connectorCount are connectors
    int _connectorCount;
    std::vector< ComponentJoint > _joints;
    int _rootComponent;

    std::optional< std::vector< Matrix > > _componentPosition;

    /**
     * \brief computes back references to joints in components
     */
    void _prepareComponents() {
        for ( auto& c: _components ) {
            c.outJoints.clear();
            c.inJoints.clear();
            c.parent = this;
        }
        for ( int i = 0; i != _joints.size(); i++ ) {
            const auto& j = _joints[ i ];
            _components[ j.sourceComponent ].outJoints.push_back( i );
            _components[ j.destinationComponent ].inJoints.push_back( i );
        }
        for ( auto& c: _components )
            c.parent = this;
    }

    /**
     * \brief Get index of root component - component with no ingoing edges
     */
    int _computeRoot() const {
        for ( int i = 0; i != _components.size(); i++ )
            if ( _components[ i ].inJoints.size() == 0 )
                return i;
        throw std::logic_error( "Module does not have a root component" );
    }

    friend class Rofibot;
};

/**
 * \brief Collision model ignoring collision
 */
class NoColision {
    /**
     * \brief Decide if two modules collide
     */
    bool operator()( const Module& a, const Module& b ) {
        return false;
    }
};

/**
 * \brief Collision model taking into account only spherical collisions of the
 * shoes
 */
class SimpleColision {
    /**
     * \brief Decide if two modules collide
     */
    bool operator()( const Module& a, const Module& b ) {
        return false;
    }
};

/**
 * \brief
 */
class Rofibot {
public:
    Rofibot() = default;

    Rofibot( const Rofibot& other )
        : _modules( other._modules ),
          _moduleJoints( other._moduleJoints ),
          _spaceJoints( other._spaceJoints ),
          _prepared( other._prepared )
    {
        _adoptModules();
    }

    Rofibot& operator=( Rofibot other ) {
        swap( other );
        return *this;
    }

    Rofibot( Rofibot&& other )
        : _modules( std::move( other._modules ) ),
          _moduleJoints( std::move( other._moduleJoints ) ),
          _spaceJoints( std::move( other._spaceJoints ) ),
          _prepared( other._prepared )
    {
        _adoptModules();
    }

    Rofibot& operator=( Rofibot&& other ) {
        swap( other );
        return *this;
    }

    void swap( Rofibot& other ) {
        using std::swap;
        swap( _modules, other._modules );
        swap( _moduleJoints, other._moduleJoints );
        swap( _spaceJoints, other._spaceJoints );
        swap( _prepared, other._prepared );
        _adoptModules();
        other._adoptModules();
    }

    /**
     * \brief Insert a module from the Rofibot.
     *
     * The module position is not specify. You should connect the module to
     * other modules via connect(). The module is assigned a unique id withing
     * the rofibot.
     *
     * Returns a reference to the newly created module.
     */
    Module& insert( Module m ) {
        ModuleId id = _modules.insert( { m, {}, {}, {}, std::nullopt } );
        Module* insertedModule = _modules[ id ].module.get();
        insertedModule->id = id;
        insertedModule->parent = this;
        insertedModule->_prepareComponents();
        return *insertedModule;
    }

    /**
     * \brief Remove a module from the Rofibot
     */
    void remove( ModuleId id ) {
        const ModuleInfo& info = _modules[ id ];
        for ( int idx : info.inJointsIdx )
            _moduleJoints.erase( idx );
        for ( int idx : info.outJointsIdx )
            _moduleJoints.erase( idx );
        for ( int idx : info.spaceJoints )
            _spaceJoints.erase( idx );
        _modules.erase( id );
    }

    /**
     * \brief Decided whether the configuration is valid
     *
     * \return A pair - first item indicates the validity, the second one gives
     * textual description of the reason for invalidity
     */
    template < typename Collision >
    std::pair< bool, std::string > isValid( Collision collisionModel = Collision() ) {
        if ( !_prepared ) {
            try {
                prepare();
            }
            catch ( const std::runtime_error& e ) {
                return { false, e.what() };
            }
        }

        for ( const ModuleInfo& m : _modules ) {
            for ( const ModuleInfo& n : _modules ) {
                if ( n.module->id >= m.module->id ) // Collision is symmetric
                    break;
                if ( collisionModel( *n.module, *m.module ) ) {
                    return { false, fmt::format("Modules {} and {} collide",
                        m.module->id, n.module->id ) };
                }
            }
        }

        for ( const ModuleInfo& m : _modules ) {
            if ( !m.position )
                return { false, fmt::format("Module {} is not rooted",
                        m.module->id) };
        }
        return { true, "" };
    }

    /**
     * \brief Precompute position of all the modules in the configuration
     *
     * Raises std::runtime_error if the configuration is inconsistent, and,
     * therefore, it cannot be
     */
    void prepare() {
        _clearModulePositions();

        // Setup position of space joints and extract roots
        std::set< ModuleId > roots;
        for ( const SpaceJoint& j : _spaceJoints ) {
            Matrix jointPosition = translate( j.refPoint ) * j.joint->sourceToDest();
            ModuleInfo& mInfo = _modules[ j.destModule ];
            Matrix componentPosition = mInfo.module->getComponentPosition( j.destComponent );
            // Reverse the comonentPosition to get position of the module origin
            Matrix modulePosition = jointPosition * arma::inv( componentPosition );
            if ( mInfo.position ) {
                if ( !equals( mInfo.position.value(), modulePosition ) )
                    throw std::runtime_error(
                        fmt::format( "Inconsistent rooting of module {}", mInfo.module->id ) );
            } else {
                mInfo.position = componentPosition;
            }
            roots.insert( mInfo.module->id );
        }

        auto dfsTraverse = [&]( ModuleInfo& m, Matrix position, auto& self ) {
            if ( m.position ) {
                if ( !equals( position, m.position.value() ) )
                    throw std::runtime_error(
                        fmt::format( "Inconsistent position of module {}", m.module->id ) );
                return;
            }
            m.position = position;
            // Traverse ignoring edge orientation
            std::vector< int > joints;
            std::copy( m.outJointsIdx.begin(), m.outJointsIdx.end(),
                std::back_inserter( joints ) );
            std::copy( m.inJointsIdx.begin(), m.inJointsIdx.end(),
                std::back_inserter( joints ) );
            for ( int outJointIdx : joints ) {
                const RoficomJoint& j = _moduleJoints[ outJointIdx ];
                Matrix jointTransf = j.sourceModule == m.module->id
                    ? j.sourceToDest()
                    : j.destToSource();
                Matrix jointRefPosition =
                    position * m.module->getComponentPosition( j.sourceConnector ) * jointTransf;
                ModuleInfo& other = _modules[ j.destModule ];
                Matrix otherConnectorPosition = other.module->getComponentPosition( j.destConnector );
                // Reverse the comonentPosition to get position of the module origin
                Matrix otherPosition = jointRefPosition * arma::inv( otherConnectorPosition );
                self( other, otherPosition, self );
            }
        };

        for ( ModuleId id : roots ) {
            ModuleInfo& m = _modules[ id ];
            dfsTraverse( m, m.position.value(), dfsTraverse );
        }

        _prepared = true;
    }

    /**
     * \brief Set position of a space joints specified by its id
     */
    void setSpaceJointPosition( int jointId, Joint::Positions p ) {
        _spaceJoints[ jointId ].joint->positions = p;
        _prepared = false;
    }

    Matrix getModuleOrientation( ModuleId id ) {
        if ( !_prepared )
            prepare();
        return _modules[ id ].position.value();
    }

private:
    void onModuleMove( ModuleId mId ) {
        _prepared = false;
    }

    void _clearModulePositions() {
        for ( ModuleInfo& m : _modules )
            m.position = std::nullopt;
    }

    void _adoptModules() {
        for ( ModuleInfo& m : _modules )
            m.module->parent = this;
    }

    struct ModuleInfo {
        atoms::ValuePtr< Module > module;  // Use value_ptr to make address of modules stable
        std::vector< int > inJointsIdx;
        std::vector< int > outJointsIdx;
        std::vector< int > spaceJoints;
        std::optional< Matrix > position;
    };

    atoms::IdSet< ModuleInfo > _modules;
    atoms::IdSet< RoficomJoint > _moduleJoints;
    atoms::IdSet< SpaceJoint > _spaceJoints;
    bool _prepared = false;

    friend void connect( const Component& c1, const Component& c2, Orientation o );
    friend class Module;
    template < typename JointT, typename... Args >
    friend int connect( const Component& c, Vector refpoint, Args&&... args );
};

/**
 * \brief Connect two modules via connector
 *
 * Requires that both modules belong to the same Rofibot, otherwise
 * std::logic_error is thrown.
 *
 */
void connect( const Component& c1, const Component& c2, Orientation o );

/**
 * \brief Connect a module's component to a point in space via given joint type
 *
 * First argument specified the component, the rest of the arguments are
 * forwarded
 *
 * Returns ID of the joint which can be used for setting parameters of the joint
 */
template < typename JointT, typename... Args >
int connect( const Component& c, Vector refpoint, Args&&... args ) {
    Rofibot& bot = *c.parent->parent;
    Rofibot::ModuleInfo& info = bot._modules[ c.parent->id ];

    auto jointId = bot._spaceJoints.insert({
        std::make_unique< JointT >( ( std::forward< Args >( args ) )... ),
        refpoint,
        info.module->id,
        info.module->componentIdx( c )
    });
    info.spaceJoints.push_back( jointId );
    bot._prepared = false;
}

} // namespace rofi