// 
// Pet Therapy.
// 

import Foundation
import Squanch

extension Pet {
    
    private static let allSpecies: [Pet] = [
        .sloth, .slothSwag,
        .trex, .trexBlue, .trexViolet, .trexYellow,
        .crow, .crowWhite,
        .panda, .pandaVest,
        .koala, .koalaPirate,
        .snail,
        .betta
    ]
    
    public static let availableSpecies: [Pet] = {
        allSpecies
            .filter { species in
                let frame = "\(species.id)_idle_front-0"
                let path = Bundle.main.path(forResource: frame, ofType: "png")
                if path == nil { printDebug("Pet", species.id, "is not available") }
                return path != nil
            }
    }()
}
