//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let crow = Pet(
        id: "crow",
        doesFly: true,
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
        speed: 1.4,
        isPaid: false
    )
    
    static let crowWhite = Pet.crow.shiny(
        id: "crow_white", isPaid: true
    )
}
