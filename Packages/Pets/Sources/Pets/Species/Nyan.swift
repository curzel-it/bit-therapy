import Foundation
import Yage

extension Species {
    static let nyan = Species.pet
        .with(id: "nyan")
        .with(movementPath: "front")
        .with(dragPath: "front")
        .with(speed: 0.9)
}
