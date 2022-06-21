//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let koala = Pet(
        id: "koala",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .backflip
                ]
            )
        ],
        movement: Movement(type: .walk, speed: 0.8)
    )
    
    static let koalaPirate = Pet.koala.shiny(id: "koala_pirate", isPaid: false)
}
