import Foundation
import Yage

extension Species {
    static let mushroomWizard = Species.pet
        .with(id: "mushroomwizard")
        .with(animation: .idle.with(loops: 50))
        .with(animation: .sleep.with(loops: 20))
        .with(speed: 0.7)
}
