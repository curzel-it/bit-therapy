//
// Pet Therapy.
//

import Combine
import SwiftUI

public class FlipHorizontallyWhenGoingLeft: Capability {
    
    private var directionCanc: AnyCancellable!
    
    public required init(with subject: Entity) {
        super.init(with: subject)
        
        directionCanc = subject.$direction.sink { [weak self] direction in
            let isGoingLeft = direction.dx < -0.0001
            self?.subject?.yAngle = isGoingLeft ? .pi : .zero
        }
    }
    
    override public func uninstall() {
        directionCanc?.cancel()
        directionCanc = nil
        super.uninstall()
    }
}
