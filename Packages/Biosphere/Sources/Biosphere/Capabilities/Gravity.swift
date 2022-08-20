//
// Pet Therapy.
//

import SwiftUI

open class Gravity: Capability {
    
    public static var isEnabled = true
        
    private var isFalling: Bool = false
    
    open override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled && Gravity.isEnabled else { return }
        guard subject?.state == .move || subject?.state == .freeFall else { return }
        
        if let groundLevel = groundLevel(from: collisions) {
            onGroundReached(at: groundLevel)
        } else {
            startFallingIfNeeded()
        }
    }
    
    open func groundLevel(from collisions: Collisions) -> CGFloat? {
        guard let body = subject?.frame else { return nil }
        let requiredSurfaceContact = body.width / 2
        
        let groundCollisions = collisions
            .filter { !$0.isEphemeral }
            .filter { body.minY < $0.intersection.minY }
        
        let groundLevel = groundCollisions
            .map { $0.intersection.minY }
            .sorted { $0 < $1 }
            .first ?? -1
        
        let surfaceContact = groundCollisions
            .filter { $0.intersection.minY == groundLevel }
            .map { $0.intersection.width }
            .reduce(0, +)
        
        return surfaceContact > requiredSurfaceContact ? groundLevel : nil
    }
    
    @discardableResult
    open func onGroundReached(at groundLevel: CGFloat) -> Bool {
        guard isFalling, let body = subject else { return false }
        isFalling = false
        
        let ground = CGPoint(
            x: body.frame.origin.x,
            y: groundLevel - body.frame.height
        )
        body.set(state: .move)
        body.set(direction: .init(dx: 1, dy: 0))
        body.set(origin: ground)
        return true
    }
    
    @discardableResult
    open func startFallingIfNeeded() -> Bool {
        guard let body = subject else { return false }
        guard !isFalling else { return false }
        isFalling = true
        body.set(state: .freeFall)
        body.set(direction: CGVector(dx: 0, dy: 8))
        return true
    }
}
