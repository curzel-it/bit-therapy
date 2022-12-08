import Foundation
import Yage

extension Species {
    static let koala = Species.pet
        .with(id: "koala")
        .with(animation: .front.with(loops: 2))
        .with(animation: .idle.with(loops: 2))
        .with(animation: .eat.with(loops: 3))
        .with(animation: .love)
        .with(animation: .backflip)
        .with(speed: 0.8)

    static let koalaPirate = Species.koala.with(id: "koala_pirate")
}

private extension EntityAnimation {
    static let backflip = EntityAnimation(id: "backflip")
}
