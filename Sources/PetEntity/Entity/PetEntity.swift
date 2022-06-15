//
// Pet Therapy.
//

import Combine
import DesignSystem
import Pets
import Physics
import Squanch
import SwiftUI

class PetEntity: PhysicsEntity {
    
    @Published fileprivate(set) var petState: PetState = .move
    
    fileprivate(set) var mainSprite: PetSprite!
    
    let species: Pet
    let habitatBounds: CGRect
    
    var storedDirection: CGVector?
    var storedFrame: CGRect?
    
    // MARK: - Init
    
    init(_ pet: Pet, size: CGSize? = nil, in bounds: CGRect) {
        species = pet
        habitatBounds = bounds
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(for: size, in: bounds),
            behaviors: PetEntity.behaviors(for: species)
        )
        speed = PetEntity.speed(for: species, size: frame.width)
        loadMainSprite()
    }
    
    // MARK: - Facing Direction
    
    override func facingDirection() -> CGVector {
        if case .action(let action) = petState {
            if let direction = action.facingDirection {
                return direction
            }
        }
        return storedDirection ?? direction
    }
    
    // MARK: - Direction Change
    
    override func set(direction newDirection: CGVector) {
        super.set(direction: newDirection)
        mainSprite?.directionChanged(to: newDirection)
    }
}

// MARK: - Pet State

extension PetEntity {
    
    func set(state: PetState) {
        printDebug("PetEntity-\(self.id)", "State changed to \(state)")
        updatePhysicBody(accordingTo: state)
        petState = state
        mainSprite?.stateChanged(to: state)
    }
    
    private func updatePhysicBody(accordingTo state: PetState) {
        if case .action(let action) = state {
            storeDirectionAndFrame()
            set(frame: action.frame(from: frame, in: habitatBounds))
            set(direction: .zero)
        } else {
            restoreDirectionAndFrame()
        }
    }
    
    private func storeDirectionAndFrame() {
        storedDirection = direction
        storedFrame = frame
    }
    
    private func restoreDirectionAndFrame() {
        set(direction: storedDirection ?? direction)
        set(frame: storedFrame ?? frame)
        storedDirection = nil
        storedFrame = nil
    }
}

// MARK: - Movements

extension PetEntity {
    
    var movement: MovesLinearly? {
        behavior(for: MovesLinearly.self)
    }
}

// MARK: - Sprites

extension PetEntity {
    
    func loadMainSprite() {
        mainSprite = PetSprite(pet: species)
        mainSprite.directionChanged(to: direction)
        mainSprite.stateChanged(to: petState)
        sprites.append(mainSprite)
    }
}

