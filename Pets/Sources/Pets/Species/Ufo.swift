//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let ufo = Pet(
        id: "ufo",
        capabilities: [
            BounceOffLateralBounds.self,
            LinearMovement.self
        ],
        movementPath: .idleFront,
        dragPath: .idleFront,
        speed: 2.4
    )
}
