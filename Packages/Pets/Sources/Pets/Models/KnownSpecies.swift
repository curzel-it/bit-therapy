import Foundation
import Schwifty

extension Pet {    
    static let allSpecies: [Pet] = [
        .ape,
        .betta,
        .catGray, .catBlue, .cat, .catBlack, .catGrumpy,
        // .clockAnalog,
        .clockDigital,
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
    
    public static var availableSpecies: [Pet] = {
        allSpecies.filter { species in
            let available = PetsAssets.isAvailable("\(species.id)_front")
            if !available { printDebug("Pet", species.id, "is not available") }
            return available
        }
    }()
    
    public static func by(id: String) -> Pet? {
        availableSpecies.first { $0.id == id }
    }
}
