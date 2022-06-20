//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let koala = Pet(
        id: "koala",
        movement: Movement(type: .walk, speed: 0.9),
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
        ]
    )
    
    static let koalaPirate = Pet.panda.shiny(id: "koala_pirate", isPaid: false)
}
