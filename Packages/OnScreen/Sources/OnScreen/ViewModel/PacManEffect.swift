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
        
        let touchedLeft = collisions.contains(.leftBound)
        let touchedRight = collisions.contains(.rightBound)
                
        if touchedLeft || touchedRight {
            printDebug(tag, "Lateral bound reached")            
            let habitatWidth = body.habitatBounds.width
            let minp = touchedRight ? 0 : 0.25
            let maxp = touchedRight ? 0.75 : 0
            let randomX = CGFloat.random(in: habitatWidth*minp...habitatWidth*maxp)
            body.set(origin: CGPoint(x: randomX, y: 30))
            body.set(state: .freeFall)
        }
    }
}
