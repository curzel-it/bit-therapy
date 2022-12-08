import Foundation
import Yage

extension Species {
    static let puppy = Species.pet
        .with(id: "puppy")
        .with(animation: .front.with(loops: 2))
        .with(animation: .bone.with(loops: 5))
        .with(animation: .eat.with(loops: 5))
        .with(animation: .sleep.with(loops: 30))
        .with(speed: 0.8)

    static let puppyMilo = Species.puppy.with(id: "puppy_milo")
}

private extension EntityAnimation {
    static let bone = EntityAnimation(id: "bone")
}
