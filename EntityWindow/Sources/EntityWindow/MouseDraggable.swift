//
//  Pet Therapy.
//

import AppKit
import Physics
import Squanch

open class MouseDraggable: Capability {
    
    public var isBeingDragged: Bool = false
    
    public func mouseDragged(with event: NSEvent) {
        guard isEnabled else { return }
        guard !isBeingDragged else { return }
        mouseDragStarted()
    }
    
    open func mouseDragStarted() {
        isBeingDragged = true
        body?.movement?.isEnabled = false
    }
    
    public func mouseUp(with event: NSEvent) {
        guard isEnabled else { return }
        guard isBeingDragged else { return }
        mouseDragEnded(for: event.window)
    }
    
    open func mouseDragEnded(for window: NSWindow?) {
        isBeingDragged = false
        body?.setPosition(fromWindow: window)
        body?.movement?.isEnabled = true
    }
}

extension PhysicsEntity {
    
    var mouseDrag: MouseDraggable? { capability(for: MouseDraggable.self) }
}

extension PhysicsEntity {
    
    func setPosition(fromWindow window: NSWindow?) {
        guard let position = window?.frame.origin else { return }
        
        let maxX = habitatBounds.maxX - frame.width
        let maxY = habitatBounds.maxY - frame.height
        
        let fixedPosition = CGPoint(
            x: min(max(0, position.x), maxX),
            y: min(max(0, maxY - position.y), maxY)
        )
        set(origin: fixedPosition)
    }
}

