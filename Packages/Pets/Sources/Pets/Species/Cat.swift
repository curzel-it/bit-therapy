import Foundation
import Yage

extension Species {
    static let cat = Species.pet
        .with(id: "cat")
        .with(animation: .front.with(loops: 5))
        .with(animation: .idle.with(loops: 2))
        .with(animation: .eat.with(loops: 10))
        .with(animation: .sleep.with(loops: 50))
        .with(speed: 0.8)

    static let catBlack = Species.cat.with(id: "cat_black")
    static let catBlue = Species.cat.with(id: "cat_blue")
    static let catGray = Species.cat.with(id: "cat_gray")
}
