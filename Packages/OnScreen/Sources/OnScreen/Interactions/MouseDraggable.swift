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
    
    func mouseUp(at point: CGPoint) {
        guard subject?.isStatic == false else { return }
        guard isEnabled else { return }
        guard isBeingDragged else { return }
        mouseDragEnded(at: point)
    }
    
    private func mouseDragEnded(at point: CGPoint) {
        guard let subject else { return }
        subject.setPosition(fromWindow: point)
        subject.set(state: .move)
        subject.movement?.isEnabled = true
    }
}

extension Entity {
    var mouseDrag: MouseDraggable? {
        capability(for: MouseDraggable.self)
    }
}

private extension Entity {
    func setPosition(fromWindow position: CGPoint) {
        frame.origin = CGPoint(
            x: position.x,
            y: worldBounds.height - position.y
        )
    }
}
