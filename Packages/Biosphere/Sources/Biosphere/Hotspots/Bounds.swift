// 
// Pet Therapy.
// 

import SwiftUI

let boundDistanceAfterScreenEnd: CGFloat = 0
let boundsThickness: CGFloat = 1000

extension Environment {
    
    func bottomBound() -> Entity {
        let entity = Entity(
            id: Hotspot.bottomBound.rawValue,
            frame: CGRect(
                x: -boundsThickness,
                y: bounds.maxY,
                width: bounds.width + boundsThickness*2,
                height: boundsThickness
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }
    
    func topBound() -> Entity {
        let entity = Entity(
            id: Hotspot.topBound.rawValue,
            frame: CGRect(
                x: -boundsThickness,
                y: bounds.minY - boundsThickness,
                width: bounds.width + boundsThickness*2,
                height: boundsThickness
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }
    
    func leftBound() -> Entity {
        let entity = Entity(
            id: Hotspot.leftBound.rawValue,
            frame: CGRect(
                x: bounds.minX - boundsThickness - boundDistanceAfterScreenEnd,
                y: -boundsThickness,
                width: boundsThickness,
                height: bounds.height + boundsThickness*2
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }
    
    func rightBound() -> Entity {
        let entity = Entity(
            id: Hotspot.rightBound.rawValue,
            frame: CGRect(
                x: bounds.maxX + boundDistanceAfterScreenEnd,
                y: -boundsThickness,
                width: boundsThickness,
                height: bounds.height + boundsThickness*2
            ),
            in: bounds
        )
        entity.isStatic = true
        return entity
    }
}
