import Foundation
import DesktopKit

extension Pet {
    
    static let koala = Pet(
        id: "koala",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
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
