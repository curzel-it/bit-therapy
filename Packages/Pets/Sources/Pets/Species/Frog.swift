import Foundation
import Yage

extension Pet {
    static let frog = Pet(
        id: "frog",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .hypno.with(loops: 5),
                    .front.with(loops: 5),
                    .side.with(loops: 5),
                    .eat.with(loops: 3)
                ]
            )
        ],
        movementPath: .walk,
        speed: 1
    )
    
    static let frogVenom = Pet.frog.shiny(id: "frog_venom", isPaid: true)
}

private extension EntityAnimation {
    static let hypno = EntityAnimation(id: "hypno")
}

