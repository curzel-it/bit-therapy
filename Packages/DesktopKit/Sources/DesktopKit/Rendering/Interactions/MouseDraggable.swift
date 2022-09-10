import AppKit
import Squanch
import Yage

class MouseDraggable: DKCapability {
    
    var isBeingDragged: Bool {
        subject?.state == .drag
    }
    
    func mouseDragged(with event: NSEvent) {
        guard isEnabled else { return }
        guard !isBeingDragged else { return }
        mouseDragStarted()
    }
    
    func mouseDragStarted() {
        subject?.set(state: .drag)
        subject?.movement?.isEnabled = false
    }
    
    func mouseUp(with event: NSEvent) {
        guard isEnabled else { return }
        guard isBeingDragged else { return }
        mouseDragEnded(for: event.window)
    }
    
    func mouseDragEnded(for window: NSWindow?) {
        subject?.set(state: .move)
        subject?.setPosition(fromWindow: window)
        subject?.movement?.isEnabled = true
    }
}

extension Entity {
    
    var mouseDrag: MouseDraggable? {
        capability(for: MouseDraggable.self)
    }
}

extension Entity {
    
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

