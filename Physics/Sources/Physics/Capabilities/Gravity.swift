//
// Pet Therapy.
//

import SwiftUI

open class Gravity: Capability {
        
    private var isFalling: Bool = false
    
    open override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        if let groundCollision = groundCollision(from: collisions) {
            onGroundReached(groundCollision)
        } else {
            startFallingIfNeeded()
        }
    }
    
    open func groundCollision(from collisions: Collisions) -> Collision? {
        collisions.with(.bottomBound)
    }
    
    @discardableResult
    open func onGroundReached(_ groundCollision: Collision) -> Bool {
        guard let body = body else { return false }
        guard isFalling else { return false }
        isFalling = false
        
        let ground = CGPoint(
            x: body.frame.origin.x,
            y: groundCollision.intersection.minY - body.frame.height
        )
        body.set(direction: .init(dx: 1, dy: 0))
        body.set(origin: ground)
        return true
    }
    
    @discardableResult
    open func startFallingIfNeeded() -> Bool {
        guard let body = body else { return false }
        guard !isFalling else { return false }
        isFalling = true
        
        body.set(direction: CGVector(dx: 0, dy: 8))
        return true
    }
}
