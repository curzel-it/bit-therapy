//
// Pet Therapy.
//

import SwiftUI

open class BounceOnLateralCollision: Capability {
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let angle = bouncingAngle(collisions: collisions) else { return }
        body?.set(direction: CGVector(radians: angle))
    }
    
    func bouncingAngle(collisions: Collisions) -> CGFloat? {
        guard let body = body, !body.isEphemeral else { return nil }
        let rad = body.direction.radians
        
        let isGoingLeft = body.direction.dx < -0.0001
        let isGoingRight = body.direction.dx > 0.0001
        
        if isGoingLeft && collisions.contains(.leftBound) { return CGFloat.pi - rad }
        if isGoingRight && collisions.contains(.rightBound) { return CGFloat.pi - rad }
        
        return nil
    }
}
