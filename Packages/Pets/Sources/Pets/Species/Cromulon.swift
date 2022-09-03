import Foundation
import DesktopKit

extension Pet {
    
    static let cromulon = Pet(
        id: "cromulon",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .front,
                    .bored.with(loops: 5),
                    .talk.with(loops: 2),
                    .stare.with(loops: 3),
                    .shout.with(loops: 2)
                ]
            )
        ],
        movementPath: .front,
        speed: 0.8
    )
    
    static let cromulonPink = Pet.cromulon.shiny(id: "cromulon_pink", isPaid: false)
    static let cromulonRainbow = Pet.cromulon.shiny(id: "cromulon_rainbow", isPaid: false)
}

private extension EntityAnimation {
    static let bored = EntityAnimation(id: "bored")
    static let talk = EntityAnimation(id: "talking")
    static let stare = EntityAnimation(id: "staring")
    static let shout = EntityAnimation(id: "shouting")
}
