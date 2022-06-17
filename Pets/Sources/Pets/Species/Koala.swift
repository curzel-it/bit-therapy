//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let koala = Pet(
        id: "koala",
        movement: .walk,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .backflip
                ]
            )
        ],
        speed: 0.9,
        isPaid: false
    )
    
    static let koalaPirate = Pet.panda.shiny(
        id: "koala_pirate", isPaid: false
    )
}
