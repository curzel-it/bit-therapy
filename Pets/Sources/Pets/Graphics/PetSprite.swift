//
// Pet Therapy.
//

import Biosphere
import Schwifty
import Squanch
import SwiftUI

class PetSprite: Sprite, ObservableObject {
    
    var loopDuracy: TimeInterval { animation.loopDuracy }
    
    private let entityId: String
    private let species: Pet
    private var animation: AnimatedImage = .none
    private var lastState: PetState = .drag
    private var lastDirection: CGVector = .zero
    private var tag: String { "PetSprite-\(entityId)" }
    
    init(pet: Pet, id: String) {
        species = pet
        entityId = id
        super.init()
    }
    
    convenience init(
        pet: Pet,
        entityId: String,
        state: PetState,
        direction: CGVector = .zero
    ) {
        self.init(pet: pet, id: entityId)
        self.directionChanged(to: direction)
        self.stateChanged(to: state)
    }
    
    func directionChanged(to newDirection: CGVector) {
        self.lastDirection = newDirection
        self.update()
    }
    
    func stateChanged(to newState: PetState) {
        self.lastState = newState
        self.update()
    }
    
    private func update() {
        let path = animationPathForLastState()
        guard path != animation.baseName else { return }
        printDebug(tag, "Loaded", path)
        animation = AnimatedImage(path, frameTime: frameTime())
    }
    
    private func frameTime() -> TimeInterval {
        if case .animation(let animation) = lastState,
           let time = animation.frameTime {
            return time
        }
        return species.frameTime
    }
    
    private func animationPathForLastState() -> String {
        if case .smokeBomb = lastState { return "smoke_bomb" }
        let animation = lastState.actionPath(for: species)
        return "\(species.id)_\(animation)"
    }
    
    override func update(with collisions: Collisions, after time: TimeInterval) {
        animation.update(after: time)
        currentFrame = animation.currentFrame
    }
    
    override func kill() {
        self.animation = .none
        super.kill()
    }
}

extension PetState {
    
    func actionPath(for pet: Pet) -> String {
        switch self {
        case .freeFall: return pet.dragPath
        case .drag: return pet.dragPath
        case .move: return pet.movementPath
        case .jump: return "jump"
        case .smokeBomb: return "smoke_bomb"
        case .animation(let animation): return animation.id
        }
    }
}
