//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let trex = Pet(
        id: "trex",
        doesFly: false,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
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
        speed: 1,
        isPaid: false
    )
    
    static let trexBlue = Pet.trex.shiny(id: "trex_blue")
    static let trexViolet = Pet.trex.shiny(id: "trex_violet")
    static let trexYellow = Pet.trex.shiny(id: "trex_yellow")
}
