import Foundation
import Yage

extension Pet {    
    static let koala = Pet(
        id: "koala",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 2),
                    .idle.with(loops: 2),
                    .eat.with(loops: 3),
                    .love,
                    .backflip
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let koalaPirate = Pet.koala.shiny(id: "koala_pirate", isPaid: false)
}

private extension EntityAnimation {
    static let backflip = EntityAnimation(id: "backflip")
}
