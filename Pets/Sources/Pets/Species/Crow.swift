//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let crow = Pet(
        id: "crow",
        movement: .fly,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love
                ]
            )
        ],
        speed: 1.4
    )
    
    static let crowWhite = Pet.crow.shiny(
        id: "crow_white", isPaid: true
    )
}
