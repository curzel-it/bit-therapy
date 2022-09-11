import SwiftUI
import Yage

extension World {
    
    func verticalCenter() -> Entity {
        let entity = Entity(
            id: Hotspot.verticalCenter.rawValue,
            frame: CGRect(
                x: -boundsThickness,
                y: bounds.midY,
                width: bounds.maxX + boundsThickness*2,
                height: 1
            ),
            in: bounds
        )
        entity.isEphemeral = true
        entity.isStatic = true
        return entity
    }
    
    func horizontalCenter() -> Entity {
        let entity = Entity(
            id: Hotspot.horizontalCenter.rawValue,
            frame: CGRect(
                x: bounds.midX,
                y: -boundsThickness,
                width: 1,
                height: bounds.maxY + boundsThickness*2
            ),
            in: bounds
        )
        entity.isEphemeral = true
        entity.isStatic = true
        return entity
    }
    
    func center() -> Entity {
        let entity = Entity(
            id: Hotspot.center.rawValue,
            frame: CGRect(
                x: bounds.midX,
                y: bounds.midY,
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
