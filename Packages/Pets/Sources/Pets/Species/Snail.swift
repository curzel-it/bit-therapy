//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let snail = Pet(
        id: "snail",
        capabilities: .defaultsCrawler,
        movementPath: .front,
        dragPath: .front,
        speed: 0.2
    )
    
    static let snailNicky = Pet.snail.shiny(id: "snail_nicky")
}
