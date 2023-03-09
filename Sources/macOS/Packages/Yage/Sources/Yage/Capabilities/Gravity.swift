import Schwifty
import SwiftUI

public class Gravity: Capability {
    static let fallDirection = CGVector(dx: 0, dy: 8)

    private var isFalling: Bool {
        subject?.state == .freeFall
    }

    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard let state = subject?.state else { return }
        guard state != .drag && !isAnimationThatRequiresNoGravity(state) else { return }
        
        if let groundLevel = groundLevel(from: collisions) {
            onGroundReached(at: groundLevel)
        } else {
            startFallingIfNeeded()
        }
    }

    func groundLevel(from collisions: Collisions) -> CGFloat? {
        guard let body = subject?.frame else { return nil }
        let requiredSurfaceContact = body.width / 2

        let groundCollisions = collisions
            .filter { $0.other?.isStatic == true }
            .filter { !$0.isEphemeral }
            .filter { body.minY < $0.intersection.minY }

        let groundLevel = groundCollisions
            .map { $0.intersection.minY }
            .sorted { $0 < $1 }
            .last

        let surfaceContact = groundCollisions
            .filter { $0.intersection.minY == groundLevel }
            .map { $0.intersection.width }
            .reduce(0, +)

        return surfaceContact > requiredSurfaceContact ? groundLevel : nil
    }

    @discardableResult
    func onGroundReached(at groundLevel: CGFloat) -> Bool {
        guard let subject else { return false }
        let targetY = groundLevel - subject.frame.height
        let isLanding = isFalling
        let isRaising = !isFalling && subject.frame.minY != targetY

        if isLanding || isRaising {
            let ground = CGPoint(x: subject.frame.origin.x, y: targetY)
            subject.frame.origin = ground
        }
        if isLanding {
            subject.movement?.isEnabled = true
            subject.direction = .init(dx: 1, dy: 0)
            subject.set(state: .move)
        }
        return true
    }

    @discardableResult
    func startFallingIfNeeded() -> Bool {
        guard let subject, let movement = subject.movement, !isFalling else { return false }
        subject.set(state: .freeFall)
        subject.direction = Gravity.fallDirection
        subject.speed = 14
        movement.isEnabled = true
        return true
    }

    private func isAnimationThatRequiresNoGravity(_ state: EntityState) -> Bool {
        if case .action(let anim, _) = state {
            if anim.position != .fromEntityBottomLeft { return true }
            if anim.size != nil { return true }
        }
        return false
    }
}

public extension Entity {
    func setGravity(enabled: Bool) {
        let gravity = capability(for: Gravity.self)
        gravity?.isEnabled = enabled
        if !enabled {
            if direction.dy > 0 {
                direction = .init(dx: 1, dy: 0)
            }
            set(state: .move)
        }
    }
}
