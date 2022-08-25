//
//  Pet Therapy.
//

import AppKit
import Biosphere
import Squanch

open class RightClickable: Capability {
        
    open func onRightClick(with event: NSEvent) {
        // ...
    }
}

extension Entity {
    
    var rightClick: RightClickable? { capability(for: RightClickable.self) }
}
