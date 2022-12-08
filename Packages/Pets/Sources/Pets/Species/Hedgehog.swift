import Foundation
import Yage

extension Species {
    static let hedgehog = Species.pet
        .with(id: "hedgehog")
        .with(animation: .front.with(loops: 4))
        .with(animation: .sleep.with(loops: 10))
        .with(animation: .eat.with(loops: 4))
        .with(animation: .ball)
        .with(speed: 0.6)
}

private extension EntityAnimation {
    static let ball = EntityAnimation(id: "ball")
}
