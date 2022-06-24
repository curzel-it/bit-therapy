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
                possibleAnimations: [
                    .bombing,
                    .landing,
                    .exitViaPortal
                ]
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
        chance: 0.1
    )
    
    static let landing = EntityAnimation(id: "landing", chance: 0.2)
    
    static let exitViaPortal = EntityAnimation(
        id: "exit_portal",
        size: CGSize(width: 2, height: 1),
        chance: 0.2
    )
}
