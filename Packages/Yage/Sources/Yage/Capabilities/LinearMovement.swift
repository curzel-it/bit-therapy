import SwiftUI

public class LinearMovement: Capability {    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let body = subject else { return }
        let distance = movement(after: time)
        let newPosition = body.frame.origin.offset(by: distance)
        body.frame.origin = newPosition
    }
    
    func movement(after time: TimeInterval) -> CGPoint {
        guard let body = subject else { return .zero }
        return CGPoint(
            x: body.direction.dx * body.speed * time,
            y: body.direction.dy * body.speed * time
        )
    }
}

extension Entity {    
    public var movement: LinearMovement? {
        capability(for: LinearMovement.self)
    }
}
