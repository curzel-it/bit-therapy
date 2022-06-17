//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let egg = Pet(
        id: "egg",
        movement: .walk,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .jump,
                    .crack
                ]
            )
        ],
        speed: 0.4,
        isPaid: false
    )
    
    static let goldenEgg = Pet.egg.shiny(id: "egg_gold")
}

extension PetAction {
    
    static let crack = PetAction(id: "crack")
}
