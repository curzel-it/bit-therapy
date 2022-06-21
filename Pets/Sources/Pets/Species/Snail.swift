//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let snail = Pet(
        id: "snail",
        frameTime: 0.4,
        movement: Movement(type: .wallCrawler, speed: 0.2, path: "idle_front")
    )
    
    static let nickySnail = Pet.snail.shiny(id: "snail_nicky")
}
