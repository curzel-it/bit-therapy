//
// Pet Therapy.
//

import Foundation
import Biosphere

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
        movementPath: .walk,
        speed: 0.8
    )
    
    static let koalaPirate = Pet.koala.shiny(id: "koala_pirate", isPaid: false)
}
