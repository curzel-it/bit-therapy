import Foundation
import Squanch

extension Pet {
    
    static let allSpecies: [Pet] = [
        .betta,
        .catGray, .catBlue, .cat, .catBlack, .catGrumpy,
        .cromulon, .cromulonPink, .cromulonRainbow,
        .crow, .crowWhite,
        .koala, .koalaPirate,
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
