import Foundation
import Schwifty
import Yage
import YageLive

extension Species {
    static let pet = Species(id: "")
        .with(capability: AnimatedSprite.self)
        .with(capability: AnimationsProvider.self)
        .with(capability: AutoRespawn.self)
        .with(capability: BounceOnLateralCollisions.self)
        .with(capability: FlipHorizontallyWhenGoingLeft.self)
        .with(capability: LinearMovement.self)
        .with(capability: PetsSpritesProvider.self)
        .with(capability: RandomAnimations.self)
        .with(capability: Rotating.self)
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
