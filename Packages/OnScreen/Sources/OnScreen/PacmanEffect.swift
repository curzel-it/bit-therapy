//
// Pet Therapy.
//

import Biosphere
import Combine
import Squanch
import SwiftUI

class PacmanEffect: Capability {
    
    private let tag: String
    
    required init(with subject: Entity) {
        tag = "Pacman-\(subject.id)"
        super.init(with: subject)
    }
        
    override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let body = subject, body.state == .move else { return }
        guard collisions.contains(.rightBound) else { return }
        guard Random.probability(oneIn: 3) else { return }
        
        printDebug(tag, "Right bound reached")
        let habitatWidth = body.habitatBounds.width
        let randomX = habitatWidth * CGFloat.random(in: 0...0.25)
        body.set(origin: CGPoint(x: randomX, y: 30))
        body.set(state: .freeFall)
    }
}

extension PacmanEffect {
    
    static func isCompatible(with entity: Entity) -> Bool {
        guard entity.capability(for: BounceOffLateralCollisions.self) != nil else { return false }
        guard entity.capability(for: Gravity.self) != nil else { return false }
        return true
    }
}
