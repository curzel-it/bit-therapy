// 
// Pet Therapy.
// 

import Foundation

func verticalCenter(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.verticalCenter.rawValue,
        frame: CGRect(
            x: 0,
            y: habitatBounds.height/2,
            width: habitatBounds.width,
            height: 1
        ),
        in: habitatBounds
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func horizontalCenter(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.horizontalCenter.rawValue,
        frame: CGRect(
            x: habitatBounds.width/2,
            y: 0,
            width: 1,
            height: habitatBounds.height
        ),
        in: habitatBounds
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func center(in habitatBounds: CGRect) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.center.rawValue,
        frame: CGRect(
            x: habitatBounds.width/2,
            y: habitatBounds.height/2,
            width: 1,
            height: 1
        ),
        in: habitatBounds
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}
