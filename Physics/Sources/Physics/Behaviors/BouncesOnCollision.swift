//
// Pet Therapy.
//

import SwiftUI

open class BouncesOnCollision: EntityBehavior {
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let angle = bouncingAngle(collisions: collisions) else { return }
        body?.set(direction: CGVector(radians: angle))
    }
    
    func bouncingAngle(collisions: Collisions) -> CGFloat? {
        guard let body = body else { return nil }
        guard !body.isEphemeral else { return nil }
        
        let rad = body.direction.radians
        let isGoingUp = body.direction.dy < 0
        let isGoingRight = body.direction.dx > 0
        let isGoingLeft = body.direction.dx < 0        
        
        for collision in collisions {
            guard !collision.isEphemeral else { continue }
            if collision.mySide == .left && isGoingLeft {
                return CGFloat.pi - rad
            }
            if collision.mySide == .right && isGoingRight {
                return CGFloat.pi - rad
            }
            if collision.mySide == .top && isGoingUp {
                return 2 * CGFloat.pi - rad
            }
        }
        return nil
    }
}
