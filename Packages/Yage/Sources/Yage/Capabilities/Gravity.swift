import SwiftUI

public class Gravity: Capability {
    static let fallDirectioon = CGVector(dx: 0, dy: 8)
    
    private var isFalling: Bool = false
    
    public weak var subject: Entity?
    public var isEnabled: Bool = true
    
    public func install(on subject: Entity) {
        self.subject = subject
    }
    
    public func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard subject?.state == .move || subject?.state == .freeFall else { return }
        
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
        body.set(state: .freeFall)
        body.set(direction: Gravity.fallDirectioon)
        return true
    }
    
    public func kill() {
        subject = nil
        isEnabled = false
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
