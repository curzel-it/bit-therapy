import Foundation
import Yage

extension Species {
    static let trex = Species.pet
        .with(id: "trex")
        .with(animation: .front.with(loops: 2))
        .with(animation: .idle)
        .with(animation: .eat.with(loops: 4))
        .with(animation: .selfie.with(loops: 2))
        .with(animation: .sendText.with(loops: 2))
        .with(animation: .roar.with(loops: 3))
        .with(animation: .playGuitar.with(loops: 3))
        .with(animation: .fireball.with(loops: 2))
        .with(speed: 1)

    static let trexBlue = Species.trex.with(id: "trex_blue")
    static let trexViolet = Species.trex.with(id: "trex_violet")
    static let trexYellow = Species.trex.with(id: "trex_yellow")
}

private extension EntityAnimation {
    static let fireball = EntityAnimation(id: "fireball")
    static let playGuitar = EntityAnimation(id: "guitar")
    static let roar = EntityAnimation(id: "roar")
    static let selfie = EntityAnimation(id: "selfie")
    static let sendText = EntityAnimation(id: "texting")
}
