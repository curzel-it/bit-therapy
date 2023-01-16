import AppKit
import Schwifty
import Yage

class MouseDraggable: Capability {
    var dragEnabled: Bool {
        isEnabled && subject?.isStatic == false
    }
    
    var isBeingDragged: Bool {
        subject?.state == .drag
    }
    
    func mouseDragged(currentDelta delta: CGSize) {
        guard dragEnabled, let subject else { return }
        subject.frame.origin = subject.frame.origin.offset(by: delta)
        if !isBeingDragged {
            mouseDragStarted()
        }
    }
    
    func mouseUp(totalDelta _: CGSize) {
        guard dragEnabled, isBeingDragged else { return }
        mouseDragEnded()
    }
    
    private func mouseDragStarted() {
        subject?.set(state: .drag)
        subject?.movement?.isEnabled = false
    }
    
    private func mouseDragEnded() {
        subject?.set(state: .move)
        subject?.movement?.isEnabled = true
    }
    
    private func offset(position: CGPoint, size: CGSize, by delta: CGSize, in bounds: CGRect) -> CGPoint {
        let point = position.offset(by: delta)
        return CGPoint(
            x: max(0, min(point.x, bounds.width - size.width)),
            y: max(0, min(point.y, bounds.height - size.height))
        )
    }
}

extension Entity {
    var mouseDrag: MouseDraggable? {
        capability(for: MouseDraggable.self)
    }
}
