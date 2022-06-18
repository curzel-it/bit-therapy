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
                actions: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .backflip
                ]
            )
        ],
        speed: 0.9
    )
    
    static let koalaPirate = Pet.panda.shiny(
        id: "koala_pirate", isPaid: false
    )
}
