import Foundation
import Yage

extension Species {
    static let sheep = Species.pet
        .with(id: "sheep")
        .with(animation: .front.with(loops: 2))
        .with(animation: .idle)
        .with(animation: .eat.with(loops: 3))
        .with(animation: .puke)
        .with(speed: 0.8)

    static let sheepBlack = Species.sheep
        .with(id: "sheep_black")
        .with(isPaid: true)
}

private extension EntityAnimation {
    static let puke = EntityAnimation(id: "puke")
}
