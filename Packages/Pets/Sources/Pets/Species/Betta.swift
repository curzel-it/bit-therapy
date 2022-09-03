import Foundation
import DesktopKit

extension Pet {
    
    static let betta = Pet(
        id: "betta",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .eat.with(loops: 2),
                    .tsundere.with(loops: 3),
                    .backflip
                ]
            )
        ],
        capabilities: .defaultsNoGravity,
        movementPath: .fly,
        speed: 1.3
    )
}

private extension EntityAnimation {
    static let tsundere = EntityAnimation(id: "tsundere")
    static let backflip = EntityAnimation(id: "backflip")
}
