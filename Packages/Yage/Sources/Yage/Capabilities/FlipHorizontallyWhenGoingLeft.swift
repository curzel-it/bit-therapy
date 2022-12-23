import Combine
import SwiftUI

public class FlipHorizontallyWhenGoingLeft: Capability {
    override public func update(with collisions: Collisions, after time: TimeInterval) {
        guard let subject, isEnabled else { return }
        updateYAngle(for: subject.direction, state: subject.state)
    }

    private func updateYAngle(for direction: CGVector, state: EntityState) {
        if case .action(let anim, _) = state, let animDirection = anim.facingDirection {
            updateYAngle(for: animDirection)
        } else {
            updateYAngle(for: direction)
        }
    }

    private func updateYAngle(for direction: CGVector) {
        let isGoingLeft = direction.dx < -0.0001
        subject?.rotation?.isFlippedHorizontally = isGoingLeft
    }
}
