//
// Pet Therapy.
//

import CoreGraphics
import Foundation

public struct Pet {
    
    public let id: String
    public let movement: Movement
    public let behaviors: [PetBehavior]
    public let speed: CGFloat
    public let isPaid: Bool
    public let frameTime: TimeInterval
    
    init(
        id: String,
        movement: Movement = .walk,
        frameTime: TimeInterval = 0.1,
        behaviors: [PetBehavior] = [],
        speed: CGFloat = 1,
        isPaid: Bool = false
    ) {
        self.id = id
        self.movement = movement
        self.frameTime = frameTime
        self.behaviors = behaviors
        self.speed = speed
        self.isPaid = isPaid
    }
}

// MARK: - Equatable

extension Pet: Equatable {
    
    public static func == (lhs: Pet, rhs: Pet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Shiny

extension Pet {
    
    func shiny(id shinyId: String, isPaid shinyPaid: Bool = false) -> Pet {
        return Pet(
            id: shinyId,
            movement: movement,
            frameTime: frameTime,
            behaviors: behaviors,
            speed: speed,
            isPaid: shinyPaid
        )
    }
}
