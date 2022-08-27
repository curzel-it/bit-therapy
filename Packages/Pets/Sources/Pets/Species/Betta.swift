//
// Pet Therapy.
//

import Foundation
import DesktopKit

extension Pet {
    
    static let betta = Pet(
        id: "betta",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .eat,
                    .tsundere
                ]
            )
        ],
        capabilities: .defaultsNoGravity,
        movementPath: .fly,
        speed: 1.3
    )
}
