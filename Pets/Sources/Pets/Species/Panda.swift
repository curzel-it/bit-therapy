//
// Pet Therapy.
//

import Foundation

extension Pet {
    
    static let panda = Pet(
        id: "panda",
        behaviors: [
            .init(
                trigger: .onAnyCorner,
                possibleAnimations: [
                    .idleFront,
                    .idle,
                    .eat,
                    .love,
                    .backflip,
                    .meditate,
                    .lightsaber(size: CGSize(width: 1.42, height: 1.2))
                ]
            )
        ],
        movement: Movement(type: .walk, speed: 0.8)
    )
    
    static let pandaVest = Pet.panda.shiny(
        id: "panda_vest", isPaid: false
    )
}
