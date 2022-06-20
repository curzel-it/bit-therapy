//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let crow = Pet(
        id: "crow",
        movement: Movement(type: .fly, speed: 1.4),
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
        ]
    )
    
    static let crowWhite = Pet.crow.shiny(id: "crow_white", isPaid: true)
}
