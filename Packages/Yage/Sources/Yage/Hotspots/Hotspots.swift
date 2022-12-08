import SwiftUI

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

extension World {
    func hotspotEntities() -> [Entity] {
        [
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

public extension Hotspot {
    var isCorner: Bool {
        switch self {
        case .topLeftCorner, .topRightCorner: return true
        case .bottomLeftCorner, .bottomRightCorner: return true
        default: return false
        }
    }

    var isAnchor: Bool { self == .horizontalCenter }

    var isLateralBound: Bool { self == .leftBound || self == .rightBound }
    var isVerticalBound: Bool { self == .topBound || self == .bottomBound }
    var isBound: Bool { isLateralBound || isVerticalBound }
}

// MARK: - Description

extension Hotspot: CustomStringConvertible {
    public var description: String { rawValue }
}

// MARK: - Collisions

public extension Collision {
    var hotspot: Hotspot? {
        Hotspot.allCases.first { $0.rawValue == bodyId }
    }
}

public extension Collisions {
    func contains(_ hotspot: Hotspot) -> Bool {
        first { $0.hotspot == hotspot } != nil
    }

    func contains(anyOf hotspots: [Hotspot]) -> Bool {
        hotspots.first { contains($0) } != nil
    }
}
