//
// Pet Therapy.
//

import CoreGraphics
import Foundation

// MARK: - Pet

struct Pet: Equatable {
    
    let id: String
    let doesFly: Bool
    let behaviors: [PetBehavior]
    let speed: CGFloat 
    let isPaid: Bool
    
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Shiny

extension Pet {
    
    func shiny(id shinyId: String, isPaid shinyPaid: Bool = false) -> Pet {
        return Pet(
            id: shinyId,
            doesFly: self.doesFly,
            behaviors: self.behaviors,
            speed: self.speed,
            isPaid: shinyPaid
        )
    }
}
