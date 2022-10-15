import Combine
import Squanch
import SwiftUI

public class AutoRespawn: Capability {
    private var collisionAlreadyHandled = false
    private(set) var outerBounds: CGRect = .zero
    
    public override func install(on subject: Entity) {
        super.install(on: subject)
        outerBounds = subject.worldBounds.inset(by: -250)
    }
        
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let subject = subject else { return }
        if !isWithinBounds(point: subject.frame.origin) {
            printDebug(tag, "Outer bounds reached, respawning...")
            teleport()
        }
    }
    
    private func teleport() {
        guard let body = subject else { return }
        let worldWidth = body.worldBounds.width
        let randomX = worldWidth * CGFloat.random(in: 0...0.25)
        body.set(origin: CGPoint(x: randomX, y: 30))
        body.set(state: .freeFall)
    }
    
    func isWithinBounds(point: CGPoint) -> Bool {
        outerBounds.contains(point)
    }
}
