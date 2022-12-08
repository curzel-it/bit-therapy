import Foundation
import PetsAssets
import Schwifty
import Yage
import YageLive

extension Species {
    static let pet = Species(id: "")
        .with(capability: RandomAnimations.self)
        .with(capability: AnimatedSprite.self)
        .with(capability: PetAnimationsProvider.self)
        .with(capability: PetsSpritesProvider.self)
        .with(capability: LinearMovement.self)
        .with(capability: BounceOnLateralCollisions.self)
        .with(capability: FlipHorizontallyWhenGoingLeft.self)
}

public extension Species {
    internal static let allSpecies: [Species] = [
        .ape,
        .betta,
        .catGray, .catBlue, .cat, .catBlack, .catGrumpy,
        .cromulon, .cromulonPink, .cromulonRainbow,
        .crow, .crowWhite,
        .frog, .frogVenom,
        .koala, .koalaPirate,
        .hedgehog,
        .mushroom, .mushroomAmanita,
        .mushroomWizard,
        .nyan,
        .sheep, .sheepBlack,
        .snail, .snailNicky,
        .sloth, .slothSwag,
        .sunflower,
        .trex, .trexBlue, .trexViolet, .trexYellow,
        .panda, .pandaVest,
        .puppyMilo,
        .ufo
    ]

    static var availableSpecies: [Species] = allSpecies.filter { species in
        let available = PetsAssetsProvider.shared.assetsAvailable(for: species.id)
        if !available {
            Logger.log("Pet", species.id, "is not available")
        }
        return available
    }

    static func by(id: String) -> Species? {
        availableSpecies.first { $0.id == id }
    }
}
