import Foundation
import Yage

extension Species {
    static let cromulon = Species.pet
        .with(id: "cromulon")
        .with(animation: .front)
        .with(animation: .bored.with(loops: 15))
        .with(animation: .talk.with(loops: 2))
        .with(animation: .stare.with(loops: 15))
        .with(animation: .shout.with(loops: 2))
        .with(movementPath: "front")
        .with(speed: 0.6)

    static let cromulonPink = Species.cromulon.with(id: "cromulon_pink")
    static let cromulonRainbow = Species.cromulon.with(id: "cromulon_rainbow")
}

private extension EntityAnimation {
    static let bored = EntityAnimation(id: "bored")
    static let talk = EntityAnimation(id: "talking")
    static let stare = EntityAnimation(id: "staring")
    static let shout = EntityAnimation(id: "shouting")
}
