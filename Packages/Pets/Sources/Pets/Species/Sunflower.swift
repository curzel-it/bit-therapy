import Foundation
import Yage

extension Species {
    static let sunflower = Species.pet
        .with(id: "sunflower")
        .with(fps: 0.5)
        .with(movementPath: "front")
        .with(dragPath: "front")
        .with(speed: 0)
}
