// 
// Pet Therapy.
// 

import Foundation

func topLeftCorner(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.topLeftCorner.rawValue,
        frame: CGRect(
            x: 0,
            y: 0,
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

func bottomLeftCorner(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.bottomLeftCorner.rawValue,
        frame: CGRect(
            x: 0,
            y: habitatBounds.height,
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

func topRightCorner(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.topRightCorner.rawValue,
        frame: CGRect(
            x: habitatBounds.width,
            y: 0,
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

func bottomRightCorner(in habitatBounds: CGRect) -> Entity {
    let entity = Entity(
        id: Hotspot.bottomRightCorner.rawValue,
        frame: CGRect(
            x: habitatBounds.width,
            y: habitatBounds.height,
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
