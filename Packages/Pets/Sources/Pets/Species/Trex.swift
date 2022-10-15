import Foundation
import Yage

extension Pet {    
    static let trex = Pet(
        id: "trex",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front.with(loops: 2),
                    .idle,
                    .eat.with(loops: 4),
                    .selfie.with(loops: 2),
                    .sendText.with(loops: 2),
                    .roar.with(loops: 3),
                    .playGuitar.with(loops: 3),
                    .fireball.with(loops: 2)
                ]
            )
        ],
        movementPath: .walk,
        speed: 1
    )
    
    static let trexBlue = Pet.trex.shiny(id: "trex_blue")
    static let trexViolet = Pet.trex.shiny(id: "trex_violet")
    static let trexYellow = Pet.trex.shiny(id: "trex_yellow")
}

private extension EntityAnimation {
    static let fireball = EntityAnimation(id: "fireball")
    static let playGuitar = EntityAnimation(id: "guitar")
    static let roar = EntityAnimation(id: "roar")
    static let selfie = EntityAnimation(id: "selfie")
    static let sendText = EntityAnimation(id: "texting")
}
