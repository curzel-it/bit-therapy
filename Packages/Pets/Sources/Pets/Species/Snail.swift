//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let snail = Pet(
        id: "snail",
        capabilities: [
            AnimatedSprite.self,
            LinearMovement.self,
            WallCrawler.self
        ],
        movementPath: .idleFront,
        dragPath: .idleFront,
        speed: 0.2
    )
    
    static let snailNicky = Pet.snail.shiny(id: "snail_nicky")
}
