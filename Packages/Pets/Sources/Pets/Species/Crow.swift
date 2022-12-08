import Foundation
import Yage

extension Species {
    static let crow = Species.pet
        .with(id: "crow")
        .with(animation: .front.with(loops: 3))
        .with(animation: .idle.with(loops: 2))
        .with(animation: .eat.with(loops: 2))
        .with(animation: .love)
        .with(movementPath: "fly")
        .with(speed: 1.4)

    static let crowWhite = Species.crow
        .with(id: "crow_white")
        .with(isPaid: true)
}
