import SwiftUI

let boundDistanceAfterScreenEnd: CGFloat = 0
let boundsThickness: CGFloat = 1000

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
                x: -boundsThickness,
                y: bounds.maxY,
                width: bounds.width + boundsThickness * 2,
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
                x: -boundsThickness,
                y: bounds.minY - boundsThickness,
                width: bounds.width + boundsThickness * 2,
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
                x: bounds.minX - boundsThickness - boundDistanceAfterScreenEnd,
                y: -boundsThickness,
                width: boundsThickness,
                height: bounds.height + boundsThickness * 2
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
                x: bounds.maxX + boundDistanceAfterScreenEnd,
                y: -boundsThickness,
                width: boundsThickness,
                height: bounds.height + boundsThickness * 2
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }
}
