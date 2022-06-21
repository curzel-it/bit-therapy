//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let crow = Pet(
        id: "crow",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love
                ]
            )
        ],
        capabilities: [
            LinearMovement.self,
            BounceOffLateralBounds.self
        ],
        movementPath: .fly,
        speed: 1.4
    )
    
    static let crowWhite = Pet.crow.shiny(id: "crow_white", isPaid: true)
}
