import Foundation
import Yage

extension Species {
    public static let sloth = Species.pet
        .with(id: "sloth")
        .with(animation: .front.with(loops: 2))
        .with(animation: .idle)
        .with(animation: .eat.with(loops: 2))
        .with(animation: .love)
        .with(animation: .selfie.with(loops: 2))
        .with(animation: .lightsaber(size: CGSize(width: 3.36, height: 1.86)))
        .with(capability: ReactToHotspots.self)
        .with(animation: .climb(to: .worldTopLeft).with(loops: 2), when: .on(spot: .bottomLeftCorner))
        .with(animation: .climb(to: .worldTopRight).with(loops: 2), when: .on(spot: .bottomRightCorner))
        .with(speed: 0.6)

    static let slothSwag = Species.sloth
        .with(id: "sloth_swag")
        .with(isPaid: true)
}

private extension EntityAnimation {
    static let selfie = EntityAnimation(id: "selfie")

    static func climb(to position: Position) -> EntityAnimation {
        .init(id: "climb", position: position, facingDirection: CGVector(dx: 1, dy: 0))
    }
}
