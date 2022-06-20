//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let betta = Pet(
        id: "betta",
        movement: Movement(type: .fly, speed: 1.3),
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .eat,
                    .tsundere
                ]
            )
        ]
    )
}
