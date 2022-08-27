//
// Pet Therapy.
//

import Foundation
import DesktopKit

extension Pet {
    
    static let crow = Pet(
        id: "crow",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .idle,
                    .eat,
                    .love
                ]
            )
        ],
        capabilities: .defaultsNoGravity,
        movementPath: .fly,
        speed: 1.4
    )
    
    static let crowWhite = Pet.crow.shiny(id: "crow_white", isPaid: true)
}
