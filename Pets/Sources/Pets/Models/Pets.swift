//
// Pet Therapy.
//

import CoreGraphics
import Foundation
import Biosphere

public struct Pet {
    
    public let id: String
    public let behaviors: [PetBehavior]
    public let capabilities: [Capability.Type]
    public let frameTime: TimeInterval
    public let isPaid: Bool
    public let movement: Movement
    
    init(
        id: String,
        behaviors: [PetBehavior] = [],
        capabilities: [Capability.Type] = [],
        frameTime: TimeInterval = 0.1,
        isPaid: Bool = false,
        movement: Movement
    ) {
        self.id = id
        self.behaviors = behaviors
        self.capabilities = capabilities + movement.capabilities()
        self.movement = movement
        self.frameTime = frameTime
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
            behaviors: behaviors,
            capabilities: capabilities,
            frameTime: frameTime,
            isPaid: shinyPaid,
            movement: movement
        )
    }
}
