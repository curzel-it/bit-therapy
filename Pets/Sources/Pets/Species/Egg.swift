//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let egg = Pet(
        id: "egg",
        movement: Movement(type: .walk, speed: 0.4),
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .jump,
                    .crack
                ]
            )
        ]
    )
    
    static let goldenEgg = Pet.egg.shiny(id: "egg_gold")
}

extension PetAction {
    
    static let crack = PetAction(id: "crack")
}
