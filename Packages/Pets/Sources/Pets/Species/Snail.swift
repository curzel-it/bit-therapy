import Foundation
import Yage

extension Species {
    static let snail = Species.pet
        .with(id: "snail")
        .with(capability: WallCrawler.self)
        .with(fps: 1)
        .with(movementPath: "front")
        .with(dragPath: "front")
        .with(speed: 0.2)

    static let snailNicky = Species.snail.with(id: "snail_nicky")
}
