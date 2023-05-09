import SwiftUI

public class BounceOnLateralCollisions: Capability {
    public var customCollisionsFilter: ((Collision) -> Bool)?
    
    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard let subject, !subject.isEphemeral, subject.state == .move else { return }
        guard let angle = bouncingAngle(from: subject.direction.radians, with: collisions) else { return }
        subject.direction = CGVector(radians: angle)
    }

    func bouncingAngle(from currentAngle: CGFloat, with collisions: Collisions) -> CGFloat? {
        guard let targetSide = targetSide() else { return nil }
        let validCollisions = collisions.filter { isValidCollision($0) }
        guard validCollisions.contains(overlapOnSide: targetSide) else { return nil }
        guard !validCollisions.contains(overlapOnSide: targetSide.opposite) else { return nil }
        return CGFloat.pi - currentAngle
    }
    
    private func isValidCollision(_ collision: Collision) -> Bool {
        if let filter = customCollisionsFilter {
            return filter(collision)
        } else {
            return collision.other?.isStatic == true
        }
    }

    private func targetSide() -> Collision.Side? {
        guard let direction = subject?.direction.dx else { return nil }
        if direction < -0.0001 { return .left }
        if direction > 0.0001 { return .right }
        return nil
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

public extension Entity {
    func setBounceOnLateralCollisions(enabled: Bool) {
        capability(for: BounceOnLateralCollisions.self)?.isEnabled = enabled
    }
}
