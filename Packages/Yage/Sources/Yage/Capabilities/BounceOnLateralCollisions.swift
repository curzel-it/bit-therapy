import SwiftUI

public class BounceOnLateralCollisions: Capability {
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let body = subject, !body.isEphemeral, body.state == .move else { return }
        guard let angle = bouncingAngle(from: body.direction.radians, with: collisions) else { return }
        body.direction = CGVector(radians: angle)
    }
    
    func bouncingAngle(from currentAngle: CGFloat, with collisions: Collisions) -> CGFloat? {
        guard let targetSide = targetSide() else { return nil }
        guard collisions.contains(overlapOnSide: targetSide) else { return nil }
        guard !collisions.contains(overlapOnSide: targetSide.opposite) else { return nil }
        return CGFloat.pi - currentAngle
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

private extension Collision.Side {
    var opposite: Collision.Side {
        switch self {
        case .top: return .bottom
        case .bottom: return .top
        case .left: return .right
        case .right: return .left
        }
    }
}

extension Entity {
    public func setBounceOnLateralCollisions(enabled: Bool) {
        capability(for: BounceOnLateralCollisions.self)?.isEnabled = enabled
    }
}
