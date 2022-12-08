import Foundation
import Yage

extension Species {
    static let panda = Species.pet
        .with(id: "panda")
        .with(animation: .front.with(loops: 3))
        .with(animation: .idle.with(loops: 2))
        .with(animation: .eat.with(loops: 5))
        .with(animation: .love)
        .with(animation: .backflip)
        .with(animation: .meditate.with(loops: 20))
        .with(animation: .selfie.with(loops: 3))
        .with(animation: .lightsaber(size: CGSize(width: 1.42, height: 1.2)))
        .with(speed: 0.8)

    static let pandaVest = Species.panda
        .with(id: "panda_vest")
        .with(isPaid: false)
}

private extension EntityAnimation {
    static let backflip = EntityAnimation(id: "backflip")
    static let meditate = EntityAnimation(id: "meditate")
    static let selfie = EntityAnimation(id: "selfie")
}
