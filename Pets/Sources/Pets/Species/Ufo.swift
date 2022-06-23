//
// Pet Therapy.
//

import Foundation
import Biosphere

extension Pet {
    
    public static let ufo = Pet(
        id: "ufo",
        behaviors: [
            .init(
                trigger: .on(spot: .horizontalCenter),
                possibleAnimations: [.bombing]
            )
        ],
        capabilities: .defaultsNoGravity,
        isPaid: true,
        movementPath: .idleFront,
        dragPath: .idleFront,
        speed: 2.4
    )
}
    
private extension EntityAnimation {
    
    static let bombing = EntityAnimation(
        id: "bombing",
        size: CGSize(width: 4, height: 2),
        position: .fromEntityBottomLeft,
        chance: 100
    )
}
