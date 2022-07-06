//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let sheep = Pet(
        id: "sheep",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
                    .puke
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let sheepBlack = Pet.sheep.shiny(
        id: "sheep_black", isPaid: true
    )
}
