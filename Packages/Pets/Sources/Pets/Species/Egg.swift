import Foundation
import Yage

extension Species {
    static let egg = Species.pet
        .with(id: "egg")
        .with(animation: .jump)
        .with(animation: .crack)
        .with(speed: 0.4)

    static let goldenEgg = Species.egg.with(id: "egg_gold")
}

private extension EntityAnimation {
    static let crack = EntityAnimation(id: "crack")
}
