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
    
    public init(
        of pet: Pet,
        size: CGSize? = nil,
        in habitatBounds: CGRect,
        installCapabilities: Bool = true
    ) {
        species = pet
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: habitatBounds, prefers: size),
            in: habitatBounds
        )
        updateSpeed()
        loadMainSprite()
        
        if installCapabilities {
            installAll(species.capabilities)
        }
    }
    
    // MARK: - Direction
    
    public override func facingDirection() -> CGVector {
        if case .animation(let animation) = petState {
            if let direction = animation.facingDirection {
                return direction
            }
        }
        return storedDirection ?? direction
    }
        
    public override func set(direction newDirection: CGVector) {
        super.set(direction: newDirection)
        mainSprite?.directionChanged(to: newDirection)
    }
    
    func updateSpeed() {
        speed = PetEntity.speed(for: species, size: frame.width)
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
        if case .animation(let animation) = state {
            storeDirectionAndFrame()
            set(frame: animation.frame(from: frame, in: habitatBounds))
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
        mainSprite = PetSprite(pet: species, id: id)
        mainSprite.directionChanged(to: direction)
        mainSprite.stateChanged(to: petState)
        sprites.append(mainSprite)
    }
}

