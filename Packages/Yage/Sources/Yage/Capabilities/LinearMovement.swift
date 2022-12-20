import SwiftUI

public class LinearMovement: Capability {
    override public func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let subject else { return }
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
