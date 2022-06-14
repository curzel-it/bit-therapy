// 
// Pet Therapy.
// 

import Foundation

public enum Hotspot: String, CaseIterable {
    case topBound
    case leftBound
    case rightBound
    case bottomBound
    
    case center
    case horizontalCenter
    case verticalCenter
    
    case topLeftCorner
    case bottomLeftCorner
    case topRightCorner
    case bottomRightCorner
}

// MARK: - Default Hotspots

extension World {
    
    func hotspots() -> [PhysicsEntity] {
        [
            topBound(habitatSize: bounds.size),
            bottomBound(habitatSize: bounds.size),
            leftBound(habitatSize: bounds.size),
            rightBound(habitatSize: bounds.size),
            
            center(habitatSize: bounds.size),
            horizontalCenter(habitatSize: bounds.size),
            verticalCenter(habitatSize: bounds.size),
            
            topLeftCorner(habitatSize: bounds.size),
            bottomLeftCorner(habitatSize: bounds.size),
            topRightCorner(habitatSize: bounds.size),
            bottomRightCorner(habitatSize: bounds.size)
        ]
    }
}

// MARK: - Properties

extension Hotspot {
    
    public var isCorner: Bool {
        switch self {
        case .topLeftCorner, .topRightCorner: return true
        case .bottomLeftCorner, .bottomRightCorner: return true
        default: return false
        }
    }
    
    public var isAnchor: Bool { self == .horizontalCenter }
    
    public var isLateralBound: Bool { self == .leftBound || self == .rightBound }
    public var isVerticalBound: Bool { self == .topBound || self == .bottomBound }
    public var isBound: Bool { isLateralBound || isVerticalBound }
}

// MARK: - Description

extension Hotspot: CustomStringConvertible {
    
    public var description: String { rawValue }
}
