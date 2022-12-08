import Foundation
import Yage

extension Species {
    static let frog = Species.pet
        .with(id: "frog")
        .with(animation: .hypno.with(loops: 5))
        .with(animation: .front.with(loops: 5))
        .with(animation: .side.with(loops: 5))
        .with(animation: .eat.with(loops: 3))
        .with(speed: 1)

    static let frogVenom = Species.frog
        .with(id: "frog_venom")
        .with(isPaid: true)
}

private extension EntityAnimation {
    static let hypno = EntityAnimation(id: "hypno")
}
