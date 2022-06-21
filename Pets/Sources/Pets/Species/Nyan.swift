//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let nyan = Pet(
        id: "nyan",
        capabilities: [
            BounceOffLateralBounds.self,
            LinearMovement.self,
            PetGravity.self
        ],
        movementPath: .idleFront,
        dragPath: .idleFront,
        speed: 0.9
    )
}
