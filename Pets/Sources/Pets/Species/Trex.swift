//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let trex = Pet(
        id: "trex",
        movement: Movement(type: .walk, speed: 1),
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
        ]
    )
    
    static let trexBlue = Pet.trex.shiny(id: "trex_blue")
    static let trexViolet = Pet.trex.shiny(id: "trex_violet")
    static let trexYellow = Pet.trex.shiny(id: "trex_yellow")
}
