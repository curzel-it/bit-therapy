//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let snail = Pet(
        id: "snail",
        movement: Movement(type: .wallCrawler, speed: 0.2, path: "idle_front"),
        frameTime: 0.4
    )
}
