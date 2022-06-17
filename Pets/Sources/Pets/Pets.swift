//
// Pet Therapy.
//

import CoreGraphics
import Foundation

// MARK: - Pet

public struct Pet: Equatable {
    
    public let id: String
    public let movement: MovementType
    public let behaviors: [PetBehavior]
    public let speed: CGFloat
    public let isPaid: Bool
    
    public static func == (lhs: Pet, rhs: Pet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Shiny

extension Pet {
    
    func shiny(id shinyId: String, isPaid shinyPaid: Bool = false) -> Pet {
        return Pet(
            id: shinyId,
            movement: self.movement,
            behaviors: self.behaviors,
            speed: self.speed,
            isPaid: shinyPaid
        )
    }
}

// MARK: - Movement Type

public enum MovementType: String {
    case walk
    case fly
    case wallCrawler
}
