import Foundation
import DesktopKit

extension Pet {
    
    static let mushroom = Pet(
        id: "mushroom",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .idle.with(loops: 50)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.3
    )
}
