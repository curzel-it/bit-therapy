//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let egg = Pet(
        id: "egg",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .jump,
                    .crack
                ]
            )
        ],
        speed: 0.4
    )
    
    static let goldenEgg = Pet.egg.shiny(id: "egg_gold")
}

extension PetAction {
    
    static let crack = PetAction(id: "crack")
}
