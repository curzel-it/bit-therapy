//
// Pet Therapy.
//

import Foundation
import DesktopKit

extension Pet {
    
    static let trex = Pet(
        id: "trex",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
                    .sendText,
                    .roar,
                    .playGuitar,
                    .fireball
                ]
            )
        ],
        movementPath: .walk,
        speed: 1
    )
    
    static let trexBlue = Pet.trex.shiny(id: "trex_blue")
    static let trexViolet = Pet.trex.shiny(id: "trex_violet")
    static let trexYellow = Pet.trex.shiny(id: "trex_yellow")
}
