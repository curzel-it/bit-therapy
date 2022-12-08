import Foundation
import Yage

public extension Species {
    static let ufo = Species.pet
        .with(id: "ufo")
        .with(animation: .bombing)
        .with(animation: .landing)
        .with(animation: .enterPortal)
        .with(animation: .crash)
        .with(isPaid: true)
        .with(movementPath: "front")
        .with(dragPath: "front")
        .with(speed: 2)
}

private extension EntityAnimation {
    static let bombing = EntityAnimation(
        id: "bombing",
        size: CGSize(width: 4, height: 2)
    )

    static let landing = EntityAnimation(id: "landing")

    static let enterPortal = EntityAnimation(
        id: "portal",
        size: CGSize(width: 2, height: 1)
    )

    static let crash = EntityAnimation(
        id: "crash",
        size: CGSize(width: 2, height: 1)
    )
}
