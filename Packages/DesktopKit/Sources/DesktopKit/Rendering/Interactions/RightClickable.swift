import AppKit
import Squanch
import Yage

open class RightClickable: DKCapability {
    open func onRightClick(with event: NSEvent) {}
}

extension Entity {    
    var rightClick: RightClickable? { capability(for: RightClickable.self) }
}
