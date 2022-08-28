import DesktopKit
import SwiftUI

extension Pet {
    
    static let panda = Pet(
        id: "panda",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
                    .love,
                    .backflip,
                    .meditate,
                    .lightsaber(size: CGSize(width: 1.42, height: 1.2))
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let pandaVest = Pet.panda.shiny(
        id: "panda_vest", isPaid: false
    )
}
