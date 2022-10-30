import Foundation
import Yage

extension Pet {
    static let cat = Pet(
        id: "cat",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 5),
                    .idle.with(loops: 2),
                    .eat.with(loops: 10),
                    .sleep.with(loops: 50)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let catBlack = Pet.cat.shiny(id: "cat_black", isPaid: false)
    static let catBlue = Pet.cat.shiny(id: "cat_blue", isPaid: false)
    static let catGray = Pet.cat.shiny(id: "cat_gray", isPaid: false)
    static let catGrumpy = Pet.cat.shiny(id: "cat_grumpy", isPaid: false)
}

private extension EntityAnimation {
    static let angry = EntityAnimation(id: "angry")
}
