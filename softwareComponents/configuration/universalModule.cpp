#include "universalModule.h"

namespace rofi {

Module buildUniversalModule( double alpha, double beta, double gamma ) {
    std::vector< Component > components = {
        Component{ ComponentType::Roficom },
        Component{ ComponentType::Roficom },
        Component{ ComponentType::Roficom },
        Component{ ComponentType::Roficom },
        Component{ ComponentType::Roficom },
        Component{ ComponentType::Roficom },
        Component{ ComponentType::UmShoe },
        Component{ ComponentType::UmBody },
        Component{ ComponentType::UmBody },
        Component{ ComponentType::UmShoe }
    };

    std::vector< ComponentJoint > joints = {
        // ToDo: Specify the joints properly
        makeJoint< RotationJoint >( 7, 6, // BodyA <-> ShoeA
            identity, Vector( { 1, 0, 0 } ), rotate( alpha, { 1, 0, 0 } ), - M_PI_2, M_PI_2 ),
        makeJoint< RotationJoint >( 8, 9 // BodyB <-> ShoeB
            , identity
            , Vector( { 1, 0, 0 } )
            , rotate( -beta, { 1, 0, 0 } )
            , - M_PI_2, M_PI_2 ),
        makeJoint< RotationJoint >( 7, 8 // BodyA <-> BodyB
            , identity
            , Vector( { 0, 0, 1 } )
            , rotate( gamma, { 0, 0, -1 } ) * translate( { 0, 0, 1 } ) * rotate( M_PI, { 0, 1, 0 } )
            , - M_PI, M_PI ),
        makeJoint< RigidJoint >( 6, 0, rotate( -M_PI_2, { 0, 1, 0 } ) ),
        makeJoint< RigidJoint >( 6, 1, identity ),
        makeJoint< RigidJoint >( 6, 2, rotate(  M_PI_2, { 0, 1, 0 } ) ),
        makeJoint< RigidJoint >( 9, 3, rotate( -M_PI_2, { 0, 1, 0 } ) ),
        makeJoint< RigidJoint >( 9, 4, identity ),
        makeJoint< RigidJoint >( 9, 5, rotate(  M_PI_2, { 0, 1, 0 } ) ),
    };

    joints[ 0 ].joint->positions = { alpha };
    joints[ 1 ].joint->positions = { beta };
    joints[ 2 ].joint->positions = { gamma };

    return Module( ModuleType::Universal, std::move( components ), 7,
        std::move( joints ) );
}

}
