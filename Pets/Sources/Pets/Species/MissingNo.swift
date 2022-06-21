//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    static let missingNo = Pet(
        id: "missingno",
        capabilities: [
            LinearMovement.self,
            BounceOffLateralBounds.self,
            PetGravity.self
        ],
        movementPath: .walk
    )
}
