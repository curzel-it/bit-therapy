//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let panda = Pet(
        id: "panda",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .backflip,
                    .meditate,
                    .lightsaber(size: CGSize(width: 1.42, height: 1.2))
                ]
            )
        ],
        capabilities: [
            LinearMovement.self,
            BounceOffLateralBounds.self,
            PetGravity.self
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let pandaVest = Pet.panda.shiny(
        id: "panda_vest", isPaid: false
    )
}
