// 
// Pet Therapy.
// 

import SwiftUI

extension Environment {
    
    func verticalCenter() -> Entity {
        let entity = Entity(
            id: Hotspot.verticalCenter.rawValue,
            frame: CGRect(
                x: 0,
                y: bounds.height/2,
                width: bounds.width,
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
                x: bounds.width/2,
                y: 0,
                width: 1,
                height: bounds.height
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
                x: bounds.width/2,
                y: bounds.height/2,
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
