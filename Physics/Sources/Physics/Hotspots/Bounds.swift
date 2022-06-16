// 
// Pet Therapy.
// 

import Foundation

private let boundDistanceAfterScreenEnd: CGFloat = 100
private let boundsThickness: CGFloat = 200

func bottomBound(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.bottomBound.rawValue,
        frame: CGRect(
            x: -boundDistanceAfterScreenEnd,
            y: habitatBounds.height,
            width: habitatBounds.width + boundDistanceAfterScreenEnd*2,
            height: boundsThickness
        ),
        in: habitatBounds
    )
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func topBound(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.topBound.rawValue,
        frame: CGRect(
            x: 0,
            y: -boundsThickness,
            width: habitatBounds.width,
            height: boundsThickness
        ),
        in: habitatBounds
    )
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func leftBound(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
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
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func rightBound(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
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
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}
