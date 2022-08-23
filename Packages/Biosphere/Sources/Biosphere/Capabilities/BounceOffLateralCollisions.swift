//
// Pet Therapy.
//

import Squanch
import SwiftUI

open class BounceOffLateralCollisions: Capability {
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let angle = bouncingAngle(collisions: collisions) else { return }
        subject?.set(direction: CGVector(radians: angle))
    }
    
    func bouncingAngle(collisions: Collisions) -> CGFloat? {
        guard let body = subject, !body.isEphemeral,
              let targetSide = targetSide(),
              collisions.contains(overlapOnSide: targetSide) else { return nil }
        return CGFloat.pi - body.direction.radians
    }
    
    private func targetSide() -> Collision.Side? {
        guard let direction = subject?.direction.dx else { return nil }
        let isGoingLeft = direction < -0.0001
        let isGoingRight = direction > 0.0001
        guard isGoingLeft || isGoingRight else { return nil }
        return isGoingLeft ? .left : .right
    }
}

private extension Collisions {
    
    func contains(overlapOnSide targetSide: Collision.Side) -> Bool {
        contains {
            guard !$0.isEphemeral else { return false }
            guard $0.isOverlapping else { return false }
            guard $0.sides().contains(targetSide) else { return false }
            return true
        }
    }
}

