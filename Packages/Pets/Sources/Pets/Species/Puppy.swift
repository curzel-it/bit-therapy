import Foundation
import DesktopKit

extension Pet {
    
    static let puppy = Pet(
        id: "puppy",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 2),
                    .bone.with(loops: 5),
                    .eat.with(loops: 5),
                    .sleep.with(loops: 30)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.8
    )
    
    static let puppyMilo = Pet.puppy.shiny(id: "puppy_milo", isPaid: false)
}

private extension EntityAnimation {
    static let bone = EntityAnimation(id: "bone")
}

