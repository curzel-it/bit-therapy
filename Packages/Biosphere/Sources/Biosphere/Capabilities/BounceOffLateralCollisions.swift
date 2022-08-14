//
// Pet Therapy.
//

import SwiftUI

open class BounceOffLateralCollisions: Capability {
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let angle = bouncingAngle(collisions: collisions) else { return }
        subject?.set(direction: CGVector(radians: angle))
    }
    
    func bouncingAngle(collisions: Collisions) -> CGFloat? {
        guard let body = subject, !body.isEphemeral else { return nil }
        let lateralCollisions = collisions.filter {
            let sides = $0.sides()
            return sides.contains(anyOf: [.left, .right])
        }
        guard lateralCollisions.count > 0 else { return nil }
        let rad = body.direction.radians
        return CGFloat.pi - rad
    }
}
