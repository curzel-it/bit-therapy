// 
// Pet Therapy.
// 

import Foundation

func topLeftCorner(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.topLeftCorner.rawValue,
        frame: CGRect(
            x: 0,
            y: 0,
            width: 1,
            height: 1
        )
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func bottomLeftCorner(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.bottomLeftCorner.rawValue,
        frame: CGRect(
            x: 0,
            y: habitatSize.height,
            width: 1,
            height: 1
        )
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func topRightCorner(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.topRightCorner.rawValue,
        frame: CGRect(
            x: habitatSize.width,
            y: 0,
            width: 1,
            height: 1
        )
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func bottomRightCorner(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.bottomRightCorner.rawValue,
        frame: CGRect(
            x: habitatSize.width,
            y: habitatSize.height,
            width: 1,
            height: 1
        )
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}
