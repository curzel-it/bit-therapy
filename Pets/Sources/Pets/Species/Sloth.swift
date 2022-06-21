//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    public static let sloth = Pet(
        id: "sloth",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .selfie,
                    .lightsaber(size: CGSize(width: 3.36, height: 1.86))
                ]
            ),
            .init(
                trigger: .on(spot: .leftBound),
                possibleAnimations: [
                    .climb(to: .topLeftCorner)
                ]
            ),
            .init(
                trigger: .on(spot: .rightBound),
                possibleAnimations: [
                    .climb(to: .topRightCorner)
                ]
            )
        ],
        capabilities: [
            LinearMovement.self,
            BounceOffLateralBounds.self,
            PetGravity.self
        ],
        movementPath: .walk,
        speed: 0.6
    )
    
    static let slothSwag = Pet.sloth.shiny(
        id: "sloth_swag", isPaid: true
    )
}

extension PetAnimation {
    
    static func climb(to position: Position) -> PetAnimation {
        let left = position == .topLeftCorner
        let direction: CGVector = .init(dx: left ? -1 : 1, dy: 0)
        
        return .init(
            id: "climb",
            position: position,
            facingDirection: direction,
            chance: 0.5
        )
    }
}
