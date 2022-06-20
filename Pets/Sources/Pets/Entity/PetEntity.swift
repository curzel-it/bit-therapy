//
// Pet Therapy.
//

import AppState
import Biosphere
import Combine
import DesignSystem
import Squanch
import SwiftUI

open class PetEntity: Entity {
    
    @Published fileprivate(set) var petState: PetState = .move
    
    fileprivate(set) var mainSprite: PetSprite!
    
    public let species: Pet
    
    var storedDirection: CGVector?
    var storedFrame: CGRect?
    
    // MARK: - Init
    
    public init(_ pet: Pet, size: CGSize? = nil, in habitatBounds: CGRect) {
        species = pet
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: habitatBounds, prefers: size),
            in: habitatBounds
        )
        speed = PetEntity.speed(for: species, size: frame.width)
        loadMainSprite()
    }
    
    // MARK: - Facing Direction
    
    public override func facingDirection() -> CGVector {
        if case .action(let action) = petState {
            if let direction = action.facingDirection {
                return direction
            }
        }
        return storedDirection ?? direction
    }
    
    // MARK: - Direction Change
    
    public override func set(direction newDirection: CGVector) {
        super.set(direction: newDirection)
        mainSprite?.directionChanged(to: newDirection)
    }
    
    // MARK: - Kill
    
    public override func kill(animated: Bool, onCompletion: @escaping () -> Void) {
        if !animated {
            super.kill()
        } else {
            set(state: .smokeBomb)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.kill(animated: false) {}
                onCompletion()
            }
        }
    }
}

// MARK: - Pet State

extension PetEntity {
    
    public func set(state: PetState) {
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

// MARK: - Sprites

extension PetEntity {
    
    public func loadMainSprite() {
        mainSprite = PetSprite(pet: species)
        mainSprite.directionChanged(to: direction)
        mainSprite.stateChanged(to: petState)
        sprites.append(mainSprite)
    }
}

