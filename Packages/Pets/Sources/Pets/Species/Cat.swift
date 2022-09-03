import Foundation
import DesktopKit

extension Pet {
    
    static let cat = Pet(
        id: "cat",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
                    .sleep
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let catGray = Pet.cat.shiny(id: "cat_gray", isPaid: false)
    static let catGrumpy = Pet.cat.shiny(id: "cat_grumpy", isPaid: false)
    static let catBlue = Pet.cat.shiny(id: "cat_blue", isPaid: false)
}

private extension EntityAnimation {
    static let sleep = EntityAnimation(id: "sleep")
}
