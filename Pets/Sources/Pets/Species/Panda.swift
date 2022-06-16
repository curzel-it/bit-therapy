//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let panda = Pet(
        id: "panda",
        doesFly: false,
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                actions: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .backflip,
                    .meditate
                ]
            )
        ],
        speed: 0.8,
        isPaid: false
    )
    
    static let pandaVest = Pet.panda.shiny(
        id: "panda_vest", isPaid: false
    )
}
