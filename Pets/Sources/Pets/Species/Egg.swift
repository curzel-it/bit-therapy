//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let egg = Pet(
        id: "egg",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .jump,
                    .crack
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.4
    )
    
    static let goldenEgg = Pet.egg.shiny(id: "egg_gold")
}

extension PetAnimation {
    
    static let crack = PetAnimation(id: "crack")
}
