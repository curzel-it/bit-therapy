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
        if !isBeingDragged {
            mouseDragStarted()
        }
        let newFrame = subject.frame.offset(x: delta.width, y: delta.height)
        subject.frame.origin = nearestPosition(for: newFrame, in: subject.worldBounds)
    }
    
    func mouseUp(totalDelta _: CGSize) -> CGPoint {
        guard dragEnabled, isBeingDragged else { return .zero }
        return mouseDragEnded()
    }
    
    private func mouseDragStarted() {
        subject?.set(state: .drag)
        subject?.movement?.isEnabled = false
    }
    
    private func mouseDragEnded() -> CGPoint {
        guard let subject else { return .zero }
        let finalPosition = nearestPosition(for: subject.frame, in: subject.worldBounds)
        subject.frame.origin = finalPosition
        subject.set(state: .move)
        subject.movement?.isEnabled = true
        return finalPosition
    }
    
    private func nearestPosition(for rect: CGRect, in bounds: CGRect) -> CGPoint {
        CGPoint(
            x: min(max(rect.minX, bounds.minX), bounds.maxX - rect.width),
            y: min(max(rect.minY, bounds.minY), bounds.maxY - rect.height)
        )
    }
}

extension Entity {
    var mouseDrag: MouseDraggable? {
        capability(for: MouseDraggable.self)
    }
}
