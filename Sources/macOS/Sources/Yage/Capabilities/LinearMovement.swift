import SwiftUI

public class LinearMovement: Capability {
    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard let subject, subject.state.canMove else { return }
        let distance = movement(after: time)
        let newPosition = subject.frame.origin.offset(by: distance)
        subject.frame.origin = newPosition
    }

    func movement(after time: TimeInterval) -> CGPoint {
        guard let subject else { return .zero }
        return CGPoint(
            x: subject.direction.dx * subject.speed * time,
            y: subject.direction.dy * subject.speed * time
        )
    }
}

public extension Entity {
    var movement: LinearMovement? {
        capability(for: LinearMovement.self)
    }
}

private extension EntityState {
    var canMove: Bool {
        self == .move || self == .freeFall
    }
}
