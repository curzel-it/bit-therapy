import Foundation
import Schwifty
import Yage
import YageLive

extension Species {
    static let pet = Species(id: "")
        .with(capability: "AnimatedSprite")
        .with(capability: "AnimationsProvider")
        .with(capability: "AutoRespawn")
        .with(capability: "BounceOnLateralCollisions")
        .with(capability: "FlipHorizontallyWhenGoingLeft")
        .with(capability: "LinearMovement")
        .with(capability: "PetsSpritesProvider")
        .with(capability: "RandomAnimations")
        .with(capability: "Rotating")
}

public extension Species {
    static let all: [Species] = [
        .ape,
        .betta,
        .catGray, .catBlue, .cat, .catBlack, .catGrumpy,
        .cromulon, .cromulonPink,
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

    static func by(id: String) -> Species? {
        all.first { $0.id == id }
    }
}
