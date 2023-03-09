import Schwifty
import SwiftUI

public class Draggable: Capability {
    private var dragEnabled: Bool {
        guard let subject else { return false }
        return isEnabled && !subject.isStatic && !subject.isEphemeral
    }
    
    public var isBeingDragged: Bool {
        subject?.state == .drag
    }
    
    public func dragged(currentDelta delta: CGSize) {
        guard dragEnabled, let subject else { return }
        if !isBeingDragged {
            dragStarted()
        }
        let newFrame = subject.frame.offset(x: delta.width, y: delta.height)
        subject.frame.origin = nearestPosition(for: newFrame, in: subject.worldBounds)
    }
    
    public func dragEnded(totalDelta _: CGSize) {
        guard dragEnabled, isBeingDragged else { return }
        dragEnded()
    }
    
    private func dragStarted() {
        subject?.set(state: .drag)
        subject?.movement?.isEnabled = false
    }
    
    private func dragEnded() {
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

public extension Entity {
    var drag: Draggable? {
        capability(for: Draggable.self)
    }
}
