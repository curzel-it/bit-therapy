import Combine
import Squanch
import SwiftUI
import Yage

public class AutoRespawn: DKCapability {
    private var collisionAlreadyHandled = false
    private(set) var outerBounds: CGRect = .zero
    
    public override func install(on subject: Entity) {
        super.install(on: subject)
        outerBounds = subject.habitatBounds.inset(by: -250)
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
        let habitatWidth = body.habitatBounds.width
        let randomX = habitatWidth * CGFloat.random(in: 0...0.25)
        body.set(origin: CGPoint(x: randomX, y: 30))
        body.set(state: .freeFall)
    }
    
    func isWithinBounds(point: CGPoint) -> Bool {
        outerBounds.contains(point)
    }
}
