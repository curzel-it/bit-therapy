//
//  Pet Therapy.
//

import AppKit
import Physics
import Squanch

open class RightClickable: Capability {
        
    open func onRightClick(with event: NSEvent) {
        // ...
    }
}

extension PhysicsEntity {
    
    var rightClick: RightClickable? { capability(for: RightClickable.self) }
}
