import DesktopKit
import SwiftUI

extension Pet {
    
    static let panda = Pet(
        id: "panda",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 3),
                    .idle.with(loops: 2),
                    .eat.with(loops: 5),
                    .love,
                    .backflip,
                    .meditate.with(loops: 20),
                    .selfie.with(loops: 3),
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

private extension EntityAnimation {
    static let backflip = EntityAnimation(id: "backflip")
    static let meditate = EntityAnimation(id: "meditate")
    static let selfie = EntityAnimation(id: "selfie")
}
