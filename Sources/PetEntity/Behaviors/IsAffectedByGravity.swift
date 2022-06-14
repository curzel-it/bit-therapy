//
// Pet Therapy.
//

import Physics
import Squanch
import SwiftUI

class IsAffectedByGravity: EntityBehavior {
    
    var pet: PetEntity? { body as? PetEntity }
        
    var isFalling: Bool { pet?.petState == .freeFall }
    
    override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        let groundCollision = collisions.first { $0.mySide == .bottom }
        
        if let groundCollision = groundCollision {
            onGroundReached(groundCollision)
        } else {
            startFallingIfNeeded()
        }
    }
    
    private func onGroundReached(_ groundCollision: Collision) {
        guard let pet = pet else { return }
        guard isFalling else { return }
        
        let ground = CGPoint(
            x: pet.frame.origin.x,
            y: groundCollision.intersection.minY - pet.frame.height
        )
        pet.set(state: .move)
        pet.set(direction: .init(dx: 1, dy: 0))
        pet.set(origin: ground)
    }
    
    private func startFallingIfNeeded() {
        guard let pet = pet else { return }
        guard AppState.global.gravityEnabled else { return }
        guard !isFalling else { return }
        pet.set(state: .freeFall)
        pet.set(direction: CGVector(dx: 0, dy: 8))
    }    
}
