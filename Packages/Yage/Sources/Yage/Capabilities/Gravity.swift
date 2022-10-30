import SwiftUI

public class Gravity: Capability {
    static let fallDirection = CGVector(dx: 0, dy: 8)
    
    private var isFalling: Bool = false
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let state = subject?.state else { return }
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
        guard let body = subject else { return false }
        let targetY = groundLevel - body.frame.height
        let isLanding = isFalling
        let isRaising = !isFalling && body.frame.minY != targetY
        isFalling = false
        
        if isLanding || isRaising {
            let ground = CGPoint(x: body.frame.origin.x, y: targetY)
            body.set(origin: ground)
        }
        if isLanding {
            body.movement?.isEnabled = true
            body.set(state: .move)
            body.set(direction: .init(dx: 1, dy: 0))
        }
        return true
    }
    
    @discardableResult
    func startFallingIfNeeded() -> Bool {
        guard let body = subject else { return false }
        guard !isFalling else { return false }
        isFalling = true
        body.movement?.isEnabled = true
        body.set(state: .freeFall)
        body.set(direction: Gravity.fallDirection)
        body.speed = 14
        return true
    }
    
    private func isAnimationThatRequiresNoGravity(_ state: EntityState) -> Bool {
        if case let .action(anim, _) = state {
            if anim.position == .fromEntityBottomLeft { return true }
            if anim.size != nil { return true }
        }
        return false
    }
}

extension Entity {
    public func setGravity(enabled: Bool) {
        if enabled {
            guard capability(for: Gravity.self) == nil else { return }
            install(Gravity())
        } else {
            uninstall(Gravity.self)
            if direction.dy > 0 {
                set(direction: .init(dx: 1, dy: 0))
            }
            set(state: .move)
        }
    }
}
