//
// Pet Therapy.
//

import CoreGraphics
import Foundation
import Biosphere

// MARK: - Movement

public struct Movement {
    
    public let type: MovementType
    public let speed: CGFloat
    public let path: String
    public let dragPath: String
    
    init(type: MovementType, speed: CGFloat = 1, dragPath: String? = nil) {
        self.type = type
        self.speed = speed
        self.path = type.path
        self.dragPath = dragPath ?? "drag"
    }
}

// MARK: - Movement Type

public enum MovementType {
    case walk
    case fly
    case custom(path: String)
    
    fileprivate var path: String {
        switch self {
        case .walk: return "walk"
        case .fly: return "fly"
        case .custom(let path): return path
        }
    }
}

// MARK: - Capabilities

extension Movement {
    
    public func capabilities() -> Capabilities {
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
        case .custom: return []
        }
    }
}
