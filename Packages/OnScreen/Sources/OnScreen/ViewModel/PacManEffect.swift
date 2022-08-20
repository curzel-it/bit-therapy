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
        guard isEnabled else { return }
        guard case .move = subject?.state else { return }
        if collisions.contains(.rightBound) {
            printDebug(tag, "Arrived at bottom right")
            subject?.set(origin: CGPoint(x: 20, y: 20))
            subject?.set(state: .freeFall)
        }
    }
}
