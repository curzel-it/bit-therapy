//
// Pet Therapy.
//

import Pets
import Biosphere
import Schwifty
import Squanch
import SwiftUI

class PetSprite: Sprite, ObservableObject {
    
    var loopDuracy: TimeInterval { animation.loopDuracy }
    
    private let species: Pet
    private var animation: AnimatedImage = .none
    private var lastState: PetState = .drag
    private var lastDirection: CGVector = .zero
    
    init(pet: Pet) {
        species = pet
        super.init()
    }
    
    convenience init(pet: Pet, state: PetState, direction: CGVector = .zero) {
        self.init(pet: pet)
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
        printDebug("PetSprite", "Loaded", path)
        animation = AnimatedImage(path, frameTime: frameTime())
    }
    
    private func frameTime() -> TimeInterval {
        if case .action(let action) = lastState, let time = action.frameTime {
            return time
        }
        return species.frameTime
    }
    
    private func animationPathForLastState() -> String {
        if case .smokeBomb = lastState { return "smoke_bomb" }
        let action = lastState.actionPath(for: species)
        return "\(species.id)_\(action)"
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
        case .freeFall: return pet.movement.dragPath
        case .drag: return pet.movement.dragPath
        case .move: return pet.movement.path
        case .jump: return "jump"
        case .smokeBomb: return "smoke_bomb"
        case .action(let action): return action.id
        }
    }
}
