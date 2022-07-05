// 
// Pet Therapy.
// 

import Foundation
import Squanch

extension Pet {
    
    static let allSpecies: [Pet] = [
        .betta,
        .crow, .crowWhite,
        .koala, .koalaPirate,
        .nyan,
        .sheep, .sheepBlack,
        .snail, .snailNicky,
        .sloth, .slothSwag,
        .trex, .trexBlue, .trexViolet, .trexYellow,
        .panda, .pandaVest,
        .ufo
    ]
    
    public static var availableSpecies: [Pet] = {
        allSpecies
            .filter { species in
                let frame = "\(species.id)_idle_front-1"
                let path = Bundle.main.path(forResource: frame, ofType: "png")
                if path == nil { printDebug("Pet", species.id, "is not available") }
                return path != nil
            }
    }()
    
    public static func by(id: String) -> Pet? {
        availableSpecies.first { $0.id == id }
    }
}
