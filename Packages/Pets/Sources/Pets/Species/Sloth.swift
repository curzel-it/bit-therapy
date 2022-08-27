//
// Pet Therapy.
//

import DesktopKit
import SwiftUI

extension Pet {
    
    public static let sloth = Pet(
        id: "sloth",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
                    .love,
                    .selfie,
                    .lightsaber(size: CGSize(width: 3.36, height: 1.86))
                ]
            ),
            .init(
                trigger: .on(spot: .bottomLeftCorner),
                possibleAnimations: [
                    .climb(to: .habitatTopLeft)
                ]
            ),
            .init(
                trigger: .on(spot: .bottomRightCorner),
                possibleAnimations: [
                    .climb(to: .habitatTopRight)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.6
    )
    
    static let slothSwag = Pet.sloth.shiny(
        id: "sloth_swag", isPaid: true
    )
}

private extension EntityAnimation {
    
    static func climb(to position: Position) -> EntityAnimation {
        let left = position == .habitatTopLeft
        let direction: CGVector = .init(dx: left ? 1 : -1, dy: 0)
        
        return .init(
            id: "climb",
            position: position,
            facingDirection: direction,
            chance: 0.5
        )
    }
}
