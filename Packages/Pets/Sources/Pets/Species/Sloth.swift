import Foundation
import Yage

extension Pet {    
    public static let sloth = Pet(
        id: "sloth",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 2),
                    .idle,
                    .eat.with(loops: 2),
                    .love,
                    .selfie.with(loops: 2),
                    .lightsaber(size: CGSize(width: 3.36, height: 1.86))
                ]
            ),
            .init(
                trigger: .on(spot: .bottomLeftCorner),
                possibleAnimations: [
                    .climb(to: .worldTopLeft).with(loops: 2),
                    .eat.with(loops: 2)
                ]
            ),
            .init(
                trigger: .on(spot: .bottomRightCorner),
                possibleAnimations: [
                    .climb(to: .worldTopRight).with(loops: 2),
                    .selfie.with(loops: 2)
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
        .init(id: "climb", position: position, facingDirection: CGVector(dx: 1, dy: 0))
    }
}
