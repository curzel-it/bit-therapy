import Foundation
import Yage

class LeavesPoopStains: LeavesTracesWhileWalking {
    override func install(on subject: Entity) {
        speciesForTraceEntities = .poopStain
        timeBetweenSpawns = 4
        traceExpirationTime = 17 / speciesForTraceEntities.fps
        super.install(on: subject)
    }
}

private extension Species {
    static let poopStain = Species(
        id: "poopstain",
        capabilities: [
            "AnimatedSprite",
            "AnimationsProvider",
            "PetsSpritesProvider"
        ],
        dragPath: "front",
        fps: 4,
        movementPath: "front",
        speed: 0,
        zIndex: -100
    )
}
