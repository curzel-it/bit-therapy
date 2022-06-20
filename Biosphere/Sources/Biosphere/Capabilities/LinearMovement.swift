//
// Pet Therapy.
//

import SwiftUI

public class LinearMovement: Capability {
    
    override public func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let body = body else { return }
        body.set(
            origin: body.frame.origin.offset(
                by: movement(after: time)
            )
        )
    }
    
    func movement(after time: TimeInterval) -> CGPoint {
        guard let body = body else { return .zero }
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
