import Combine
import Schwifty
import SwiftUI

public class AutoRespawn: Capability {
    private var collisionAlreadyHandled = false
        
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let subject = subject else { return }
        if !isWithinBounds(point: subject.frame.origin) {
            printDebug(tag, subject.id, "Teleporting...")
            teleport()
        }
    }
    
    public func teleport() {
        guard let body = subject else { return }
        let worldWidth = body.worldBounds.width
        let randomX = worldWidth * CGFloat.random(in: 0...0.25)
        body.frame.origin = CGPoint(x: randomX, y: 30)
        body.direction = CGVector(dx: 1, dy: 0)
        body.set(state: .move)
    }
    
    func outerBounds() -> CGRect {
        subject?.worldBounds.inset(by: -boundsThickness/4) ?? .zero
    }
    
    func isWithinBounds(point: CGPoint) -> Bool {
        let bounds = outerBounds()
        if bounds.contains(point) { return true }
        printDebug(tag, subject?.id ?? "", "at", point.description, "is outside", bounds.description)
        return false
    }
}
