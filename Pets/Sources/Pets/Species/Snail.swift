//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let snail = Pet(
        id: "snail",
        movement: Movement(type: .wallCrawler, path: "idle_front"),
        frameTime: 0.4,
        speed: 0.2
    )
}
