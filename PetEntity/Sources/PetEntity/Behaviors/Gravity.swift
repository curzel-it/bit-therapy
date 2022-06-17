//
// Pet Therapy.
//

import AppState
import Pets
import Physics
import Squanch
import SwiftUI

class PetGravity: Gravity {
    
    var pet: PetEntity? { body as? PetEntity }
    
    @discardableResult
    open override func onGroundReached(_ groundCollision: Collision) -> Bool {
        if super.onGroundReached(groundCollision) {
            pet?.set(state: .move)
            return true
        }
        return false
    }
    
    @discardableResult
    open override func startFallingIfNeeded() -> Bool {
        guard AppState.global.gravityEnabled else { return false }
        if super.startFallingIfNeeded() {
            pet?.set(state: .freeFall)
            return true
        }
        return false
    }
}
