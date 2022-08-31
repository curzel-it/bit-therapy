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
                    .climb(to: .habitatTopLeft), .eat
                ]
            ),
            .init(
                trigger: .on(spot: .bottomRightCorner),
                possibleAnimations: [
                    .climb(to: .habitatTopRight), .selfie
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
    
    static let selfie = EntityAnimation(id: "selfie")
    
    static func climb(to position: Position) -> EntityAnimation {
        .init(
            id: "climb",
            position: position,
            facingDirection: CGVector(dx: 1, dy: 0)
        )
    }
}
