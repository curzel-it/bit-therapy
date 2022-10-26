import Foundation
import Yage

extension Pet {
    static let frog = Pet(
        id: "frog",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 5),
                    .side.with(loops: 5),
                    .eatFly.with(loops: 1)
                ]
            )
        ],
        movementPath: .walk,
        speed: 1.2
    )
    
    static let frogVenom = Pet.frog.shiny(id: "frog_venom", isPaid: true)
}

private extension EntityAnimation {
    static let eatFly = EntityAnimation(id: "eat", size: .init(width: 2, height: 1))
}
