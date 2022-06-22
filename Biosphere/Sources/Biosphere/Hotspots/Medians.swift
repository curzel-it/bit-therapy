// 
// Pet Therapy.
// 

import Foundation

func verticalCenter(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
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
    return entity
}

func horizontalCenter(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
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
    return entity
}

func center(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
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
    return entity
}
