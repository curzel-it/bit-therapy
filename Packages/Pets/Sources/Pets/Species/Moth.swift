import Foundation
import DesktopKit

extension Pet {
    
    static let moth = Pet(
        id: "moth",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 10),
                    .idle.with(loops: 20),
                    .sleep.with(loops: 180)
                ]
            )
        ],
        capabilities: .defaultsNoGravity,
        movementPath: .fly,
        speed: 1.8
    )
}

private extension EntityAnimation {
    static let sleep = EntityAnimation(id: "sleep")
}
