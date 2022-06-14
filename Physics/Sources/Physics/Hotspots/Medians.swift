// 
// Pet Therapy.
// 

import Foundation

func verticalCenter(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.verticalCenter.rawValue,
        frame: CGRect(
            x: 0,
            y: habitatSize.height/2,
            width: habitatSize.width,
            height: 1
        )
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func horizontalCenter(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.horizontalCenter.rawValue,
        frame: CGRect(
            x: habitatSize.width/2,
            y: 0,
            width: 1,
            height: habitatSize.height
        )
    )
    entity.isEphemeral = true
    entity.isStatic = true
    entity.isDrawable = false
    entity.backgroundColor = .red
    return entity
}

func center(habitatSize: CGSize) -> PhysicsEntity {
    let entity = PhysicsEntity(
        id: Hotspot.center.rawValue,
        frame: CGRect(
            x: habitatSize.width/2,
            y: habitatSize.height/2,
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
