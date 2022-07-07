// 
// Pet Therapy.
// 

import Foundation

private let boundDistanceAfterScreenEnd: CGFloat = 0
private let boundsThickness: CGFloat = 1000

func bottomBound(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.bottomBound.rawValue,
        frame: CGRect(
            x: -boundsThickness,
            y: habitatBounds.height,
            width: habitatBounds.width + boundsThickness*2,
            height: boundsThickness
        ),
        in: habitatBounds
    )
    entity.isStatic = true
    return entity
}

func topBound(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.topBound.rawValue,
        frame: CGRect(
            x: -boundsThickness,
            y: -boundsThickness,
            width: habitatBounds.width + boundsThickness*2,
            height: boundsThickness
        ),
        in: habitatBounds
    )
    entity.isStatic = true
    return entity
}

func leftBound(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.leftBound.rawValue,
        frame: CGRect(
            x: 0 - boundsThickness - boundDistanceAfterScreenEnd,
            y: 0,
            width: boundsThickness,
            height: habitatBounds.height
        ),
        in: habitatBounds
    )
    entity.isStatic = true
    return entity
}

func rightBound(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.rightBound.rawValue,
        frame: CGRect(
            x: habitatBounds.width + boundDistanceAfterScreenEnd,
            y: 0,
            width: boundsThickness,
            height: habitatBounds.height
        ),
        in: habitatBounds
    )
    entity.isStatic = true
    return entity
}
