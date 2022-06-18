//
// Pet Therapy.
//

import CoreGraphics
import Foundation

// MARK: - Pet

public struct Pet: Equatable {
    
    public let id: String
    public let movement: MovementType
    public let usesIdleFrontAsMovement: Bool
    public let behaviors: [PetBehavior]
    public let speed: CGFloat
    public let isPaid: Bool
    public let frameTime: TimeInterval
    
    init(
        id: String,
        movement: MovementType = .walk,
        usesIdleFrontAsMovement: Bool = false,
        frameTime: TimeInterval = 0.1,
        behaviors: [PetBehavior] = [],
        speed: CGFloat = 1,
        isPaid: Bool = false
    ) {
        self.id = id
        self.movement = movement
        self.usesIdleFrontAsMovement = usesIdleFrontAsMovement
        self.frameTime = frameTime
        self.behaviors = behaviors
        self.speed = speed
        self.isPaid = isPaid
    }
    
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
            usesIdleFrontAsMovement: usesIdleFrontAsMovement,
            frameTime: self.frameTime,
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
