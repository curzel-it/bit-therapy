//
// Pet Therapy.
//

import Combine
import SwiftUI

public class FlipHorizontallyWhenGoingLeft: Capability {
    
    private var directionCanc: AnyCancellable!
    
    public required init(with body: Entity) {
        super.init(with: body)
        
        directionCanc = body.$direction.sink { [weak self] direction in
            let isGoingLeft = direction.dx < -0.0001
            self?.body?.yAngle = isGoingLeft ? .pi : .zero
        }
    }
    
    override public func uninstall() {
        directionCanc?.cancel()
        directionCanc = nil
        super.uninstall()
    }
}
