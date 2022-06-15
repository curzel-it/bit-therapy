//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    public static let sloth = Pet(
        id: "sloth",
        doesFly: false,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .selfie
                    // .lightsaber(size: CGSize(width: 336, height: 186))
                ]
            ),
            .init(
                trigger: .on(spot: .leftBound),
                actions: [
                    .climb(to: .topLeftCorner)
                ]
            ),
            .init(
                trigger: .on(spot: .rightBound),
                actions: [
                    .climb(to: .topRightCorner)
                ]
            )
        ],
        speed: 0.6,
        isPaid: false
    )
    
    static let slothSwag = Pet.sloth.shiny(
        id: "sloth_swag", isPaid: true
    )
}

extension PetAction {
    
    static func climb(to position: PetActionPosition) -> PetAction {
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
