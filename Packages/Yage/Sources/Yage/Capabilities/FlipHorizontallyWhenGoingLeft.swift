import Combine
import SwiftUI

public class FlipHorizontallyWhenGoingLeft: Capability {
    private var lastDirection: CGVector = .zero
    private var lastState: EntityState = .drag
    
    public required init(for subject: Entity) {
        lastDirection = subject.direction
        lastState = subject.state
        super.init(for: subject)
    }
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let subject = subject else { return }
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
        subject?.yAngle = isGoingLeft ? .pi : .zero
    }
}
