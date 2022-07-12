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
                y: bounds.height - safeAreaInsets.bottom,
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
                y: -boundsThickness + safeAreaInsets.top,
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
                x: 0 - boundsThickness - boundDistanceAfterScreenEnd + safeAreaInsets.leading,
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
            id: Hotspot.rightBound.rawValue,
            frame: CGRect(
                x: bounds.width + boundDistanceAfterScreenEnd - safeAreaInsets.trailing,
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
