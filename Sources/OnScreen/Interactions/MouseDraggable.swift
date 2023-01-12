import AppKit
import Schwifty
import Yage

class MouseDraggable: Capability {
    var isBeingDragged: Bool {
        subject?.state == .drag
    }
    
    func mouseDragged() {
        guard subject?.isStatic == false else { return }
        guard isEnabled else { return }
        guard !isBeingDragged else { return }
        mouseDragStarted()
    }
    
    private func mouseDragStarted() {
        subject?.set(state: .drag)
        subject?.movement?.isEnabled = false
    }
    
    func mouseUp(translation delta: CGSize) {
        guard subject?.isStatic == false else { return }
        guard isEnabled else { return }
        guard isBeingDragged else { return }
        mouseDragEnded(translatedBy: delta)
    }
    
    private func mouseDragEnded(translatedBy delta: CGSize) {
        guard let subject else { return }
        subject.frame.origin = offset(
            position: subject.frame.origin,
            size: subject.frame.size,
            by: delta,
            in: subject.worldBounds
        )
        subject.set(state: .move)
        subject.movement?.isEnabled = true
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
