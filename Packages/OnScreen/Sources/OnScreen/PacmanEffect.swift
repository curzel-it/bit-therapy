import DesktopKit
import Combine
import Squanch
import SwiftUI

class PacmanEffect: Capability {
    
    private let tag: String
    
    private var collisionAlreadyHandled = false
    
    required init(with subject: Entity) {
        tag = "Pacman-\(subject.id)"
        super.init(with: subject)
    }
        
    override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, subject?.state == .move else { return }
        guard validCollision(in: collisions) else { return }
        guard Random.probability(oneIn: 3) else { return }
        printDebug(tag, "Right bound reached, teleporting...")
        teleport()
    }
    
    private func teleport() {
        guard let body = subject else { return }
        let habitatWidth = body.habitatBounds.width
        let randomX = habitatWidth * CGFloat.random(in: 0...0.25)
        body.set(origin: CGPoint(x: randomX, y: 30))
        body.set(state: .freeFall)
    }
    
    private func validCollision(in collisions: Collisions) -> Bool {
        if collisions.contains(.rightBound) {
            let canHandle = !collisionAlreadyHandled
            collisionAlreadyHandled = true
            return canHandle
        } else {
            collisionAlreadyHandled = false
            return false
        }
    }
}

extension PacmanEffect {
    
    static func isCompatible(with entity: Entity) -> Bool {
        guard entity.capability(for: BounceOffLateralCollisions.self) != nil else { return false }
        guard entity.capability(for: Gravity.self) != nil else { return false }
        return true
    }
}
