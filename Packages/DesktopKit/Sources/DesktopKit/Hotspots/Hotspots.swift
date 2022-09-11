import SwiftUI
import Yage

class WorldWithHotspots: World {
    
    override func set(bounds: CGRect) {
        super.set(bounds: bounds)
        let hotspots = Hotspot.allCases.map { $0.rawValue }
        let oldBounds = children.filter { hotspots.contains($0.id) }
        oldBounds.forEach { $0.kill() }
        children.removeAll { hotspots.contains($0.id) }
        children.append(contentsOf: hotspotEntities())
    }
}

// MARK: - Hotspots

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

extension WorldWithHotspots {
    
    func hotspotEntities() -> [Entity] {
        return [
            topBound(),
            bottomBound(),
            leftBound(),
            rightBound(),
            
            center(),
            horizontalCenter(),
            verticalCenter(),
            
            topLeftCorner(),
            bottomLeftCorner(),
            topRightCorner(),
            bottomRightCorner()
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
