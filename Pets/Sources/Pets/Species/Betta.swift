//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let betta = Pet(
        id: "betta",
        movement: .fly,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .idleFront,
                    .eat,
                    .tsundere
                ]
            )
        ],
        speed: 1.3,
        isPaid: false
    )
}
