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
        movement: Movement(type: .walk, speed: 0.9)
    )
    
    static let koalaPirate = Pet.panda.shiny(id: "koala_pirate", isPaid: false)
}
