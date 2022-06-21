//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    public static let ufo = Pet(
        id: "ufo",
        capabilities: [
            BounceOffLateralBounds.self,
            LinearMovement.self,
            Seeker.self
        ],
        movementPath: .idleFront,
        dragPath: .idleFront,
        speed: 2.4
    )
}
