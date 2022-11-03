import Foundation
import Yage

extension Pet {
    static let hedgehog = Pet(
        id: "hedgehog",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 4),
                    .sleep.with(loops: 10),
                    .eat.with(loops: 4),
                    .ball
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.6
    )
}

private extension EntityAnimation {
    static let ball = EntityAnimation(id: "ball")
}
