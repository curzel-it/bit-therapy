//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let betta = Pet(
        id: "betta",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .eat,
                    .tsundere
                ]
            )
        ],
        movement: Movement(type: .fly, speed: 1.3)
    )
}
