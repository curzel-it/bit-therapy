import Foundation
import Yage

extension Species {
    static let mushroom = Species.pet
        .with(id: "mushroom")
        .with(animation: .idle.with(loops: 50))
        .with(speed: 0.3)

    static let mushroomAmanita = Species.mushroom
        .with(id: "mushroom_amanita")
}
