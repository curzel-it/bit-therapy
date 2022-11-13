import Foundation
import Yage

extension Pet {
    static let ape = Pet(
        id: "ape",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 5),
                    .eat.with(loops: 5),
                    .sleep.with(loops: 20)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.7
    )
}
