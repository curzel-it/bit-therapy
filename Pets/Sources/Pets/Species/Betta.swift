//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let betta = Pet(
        id: "betta",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .eat,
                    .tsundere
                ]
            )
        ],
        capabilities: .defaultsNoGravity,
        movementPath: .fly,
        speed: 1.3
    )
}
