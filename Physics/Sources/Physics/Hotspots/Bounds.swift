// 
// Pet Therapy.
// 

import Foundation

private let boundDistanceAfterScreenEnd: CGFloat = 100
private let boundsThickness: CGFloat = 200

func bottomBound(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.bottomBound.rawValue,
        frame: CGRect(
            x: -boundDistanceAfterScreenEnd,
            y: habitatSize.height,
            width: habitatSize.width + boundDistanceAfterScreenEnd*2,
            height: boundsThickness
        )
    )
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func topBound(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.topBound.rawValue,
        frame: CGRect(
            x: 0,
            y: -boundsThickness,
            width: habitatSize.width,
            height: boundsThickness
        )
    )
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func leftBound(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.leftBound.rawValue,
        frame: CGRect(
            x: 0 - boundsThickness - boundDistanceAfterScreenEnd,
            y: 0,
            width: boundsThickness,
            height: habitatSize.height
        )
    )
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func rightBound(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.rightBound.rawValue,
        frame: CGRect(
            x: habitatSize.width + boundDistanceAfterScreenEnd,
            y: 0,
            width: boundsThickness,
            height: habitatSize.height
        )
    )
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}
