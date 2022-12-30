import Schwifty
import SwiftUI

let boundsThickness: CGFloat = 2

// MARK: - Hotspots

public enum Hotspot: String, CaseIterable {
    case topBound
    case leftBound
    case rightBound
    case bottomBound
}

// MARK: - Default Hotspots

extension World {
    func hotspotEntities() -> [Entity] {
        [
            topBound(),
            bottomBound(),
            leftBound(),
            rightBound()
        ]
    }
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

// MARK: - Entities

private extension World {
    func bottomBound() -> Entity {
        let entity = Entity(
            species: .hotspot,
            id: Hotspot.bottomBound.rawValue,
            frame: CGRect(
                x: 0,
                y: bounds.height,
                width: bounds.width,
                height: boundsThickness
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }

    func topBound() -> Entity {
        let entity = Entity(
            species: .hotspot,
            id: Hotspot.topBound.rawValue,
            frame: CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: boundsThickness
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }

    func leftBound() -> Entity {
        let entity = Entity(
            species: .hotspot,
            id: Hotspot.leftBound.rawValue,
            frame: CGRect(
                x: 0,
                y: 0,
                width: boundsThickness,
                height: bounds.height
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }

    func rightBound() -> Entity {
        let entity = Entity(
            species: .hotspot,
            id: Hotspot.rightBound.rawValue,
            frame: CGRect(
                x: bounds.width,
                y: 0,
                width: boundsThickness,
                height: bounds.height
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }
}
