import AppKit
import Schwifty
import Yage

class MouseDraggable: Capability {
    var dragEnabled: Bool {
        guard let subject else { return false }
        return isEnabled && !subject.isStatic && !subject.isEphemeral
    }
    
    var isBeingDragged: Bool {
        subject?.state == .drag
    }
    
    func mouseDragged(currentDelta delta: CGSize) {
        guard dragEnabled, let subject else { return }
        if !isBeingDragged {
            mouseDragStarted()
        }
        let newFrame = subject.frame.offset(x: delta.width, y: delta.height)
        subject.frame.origin = nearestPosition(for: newFrame, in: subject.worldBounds)
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
        guard let subject else { return }
        subject.set(state: .move)
        subject.movement?.isEnabled = true
    }
    
    private func nearestPosition(for rect: CGRect, in bounds: CGRect) -> CGPoint {
        CGPoint(
            x: min(max(rect.minX, 0), bounds.width - rect.width),
            y: min(max(rect.minY, 0), bounds.height - rect.height)
        )
    }
}

extension Entity {
    var mouseDrag: MouseDraggable? {
        capability(for: MouseDraggable.self)
    }
}
