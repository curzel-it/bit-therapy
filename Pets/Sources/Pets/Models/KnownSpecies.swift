// 
// Pet Therapy.
// 

import Foundation
import Squanch

extension Pet {
    
    static let allSpecies: [Pet] = [
        .sloth, .slothSwag,
        .trex, .trexBlue, .trexViolet, .trexYellow,
        .crow, .crowWhite,
        .panda, .pandaVest,
        .koala, .koalaPirate,
        .betta,
        .snail, .nickySnail,
        .ufo,
        .nyan
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
