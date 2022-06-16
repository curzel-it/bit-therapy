//
//  Pet Therapy.
//

import AppKit
import Physics
import Squanch

open class RightClickable: EntityBehavior {
        
    open func onRightClick(with event: NSEvent) {
        // ...
    }
}

extension PhysicsEntity {
    
    var rightClick: RightClickable? { behavior(for: RightClickable.self) }
}
