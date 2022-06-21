//
// Pet Therapy.
//

import CoreGraphics
import Foundation
import Biosphere

// MARK: - Movement

public struct Movement: Equatable {
    
    public let type: MovementType
    public let speed: CGFloat
    public let path: String
    public let dragPath: String
    
    init(type: MovementType, speed: CGFloat = 1, path: String? = nil) {
        self.type = type
        self.speed = speed
        self.path = path ?? (type == .fly ? "fly" : "walk")
        self.dragPath = path ?? "drag"
    }
}

// MARK: - Movement Type

public enum MovementType {
    case walk
    case fly
    case wallCrawler
}

// MARK: - Capabilities

extension Movement {
    
    public func capabilities() -> [Capability.Type] {
        switch type {
        case .fly: return [
            LinearMovement.self,
            BounceOffLateralBounds.self
        ]
        case .walk: return [
            LinearMovement.self,
            BounceOffLateralBounds.self,
            PetGravity.self
        ]
        case .wallCrawler: return [
            LinearMovement.self,
            WallCrawler.self
        ]
        }
    }
}
