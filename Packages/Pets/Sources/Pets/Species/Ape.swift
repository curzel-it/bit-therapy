import Foundation
import Yage

extension Species {
    static let ape = Species.pet
        .with(id: "ape")
        .with(animation: .front.with(loops: 5))
        .with(animation: .eat.with(loops: 5))
        .with(animation: .sleep.with(loops: 20))
        .with(speed: 0.7)
}
