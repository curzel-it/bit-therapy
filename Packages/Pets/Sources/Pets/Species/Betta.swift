import Foundation
import Yage

extension Species {
    static let betta = Species.pet
        .with(id: "betta")
        .with(animation: .front)
        .with(animation: .eat.with(loops: 2))
        .with(animation: .tsundere.with(loops: 3))
        .with(animation: .backflip)
        .with(movementPath: "fly")
        .with(speed: 1.3)
}

private extension EntityAnimation {
    static let tsundere = EntityAnimation(id: "tsundere")
    static let backflip = EntityAnimation(id: "backflip")
}
