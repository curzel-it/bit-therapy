import AppKit
import Squanch
import Yage

open class RightClickable: Capability {
    open func onRightClick(with event: NSEvent) {}
}

extension Entity {    
    var rightClick: RightClickable? { capability(for: RightClickable.self) }
}
