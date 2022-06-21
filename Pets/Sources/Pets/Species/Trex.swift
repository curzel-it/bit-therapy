//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let trex = Pet(
        id: "trex",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .idle,
                    .eat,
                    .sendText,
                    .roar,
                    .playGuitar,
                    .fireball
                ]
            )
        ],
        capabilities: [
            LinearMovement.self,
            BounceOffLateralBounds.self,
            PetGravity.self
        ],
        movementPath: .walk,
        speed: 1
    )
    
    static let trexBlue = Pet.trex.shiny(id: "trex_blue")
    static let trexViolet = Pet.trex.shiny(id: "trex_violet")
    static let trexYellow = Pet.trex.shiny(id: "trex_yellow")
}
