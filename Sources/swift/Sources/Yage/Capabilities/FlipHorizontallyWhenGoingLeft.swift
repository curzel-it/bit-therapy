import Combine
import SwiftUI

public class FlipHorizontallyWhenGoingLeft: Capability {
    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard let subject else { return }
        flip(for: subject.direction, state: subject.state)
    }

    private func flip(for direction: CGVector, state: EntityState) {
        if case .action(let anim, _) = state, let animDirection = anim.facingDirection {
            flip(for: animDirection)
        } else {
            flip(for: direction)
        }
    }

    private func flip(for direction: CGVector) {
        let isGoingLeft = direction.dx < -0.0001
        subject?.rotation?.isFlippedHorizontally = isGoingLeft
    }
}
