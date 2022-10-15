import Foundation
import Yage

extension Pet {    
    static let sheep = Pet(
        id: "sheep",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 2),
                    .idle,
                    .eat.with(loops: 3),
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

private extension EntityAnimation {
    static let puke = EntityAnimation(id: "puke")
}
