import SwiftUI

extension World {    
    func topLeftCorner() -> Entity {
        let entity = Entity(
            id: Hotspot.topLeftCorner.rawValue,
            frame: CGRect(
                x: 0,
                y: 0,
                width: 1,
                height: 1
            ),
            in: bounds
        )
        entity.isEphemeral = true
        entity.isStatic = true
        return entity
    }
    
    func bottomLeftCorner() -> Entity {
        let entity = Entity(
            id: Hotspot.bottomLeftCorner.rawValue,
            frame: CGRect(
                x: 0,
                y: bounds.height,
                width: 1,
                height: 1
            ),
            in: bounds
        )
        entity.isEphemeral = true
        entity.isStatic = true
        return entity
    }
    
    func topRightCorner() -> Entity {
        let entity = Entity(
            id: Hotspot.topRightCorner.rawValue,
            frame: CGRect(
                x: bounds.width,
                y: 0,
                width: 1,
                height: 1
            ),
            in: bounds
        )
        entity.isEphemeral = true
        entity.isStatic = true
        return entity
    }
    
    func bottomRightCorner() -> Entity {
        let entity = Entity(
            id: Hotspot.bottomRightCorner.rawValue,
            frame: CGRect(
                x: bounds.width,
                y: bounds.height,
                width: 1,
                height: 1
            ),
            in: bounds
        )
        entity.isEphemeral = true
        entity.isStatic = true
        return entity
    }
}
