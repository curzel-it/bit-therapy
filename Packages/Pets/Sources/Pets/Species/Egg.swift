import Foundation
import Yage

extension Pet {
    static let egg = Pet(
        id: "egg",
        behaviors: [
            .init(
                trigger: .random,
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

private extension EntityAnimation {
    static let crack = EntityAnimation(id: "crack")
}
