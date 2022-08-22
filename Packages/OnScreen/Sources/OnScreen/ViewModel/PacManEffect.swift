//
// Pet Therapy.
//

import Combine
import Biosphere
import Squanch
import SwiftUI

public class PacManEffect: Capability {
    
    private let tag: String
    
    public required init(with subject: Entity) {
        tag = "PacMan-\(subject.id)"
        super.init(with: subject)
    }
    
    // MARK: - Handle Hotspots
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let body = subject, body.state == .move else { return }
        guard collisions.contains(.rightBound) else { return }
        
        printDebug(tag, "Right bound reached")
        let habitatWidth = body.habitatBounds.width
        let randomX = habitatWidth * CGFloat.random(in: 0...0.25)
        body.set(origin: CGPoint(x: randomX, y: 30))
        body.set(state: .freeFall)
    }
}
