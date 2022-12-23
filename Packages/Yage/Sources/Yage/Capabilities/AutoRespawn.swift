import Combine
import Schwifty
import SwiftUI

public class AutoRespawn: Capability {
    override public func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let subject else { return }
        if !isWithinBounds(point: subject.frame.origin) {
            Logger.log(tag, subject.id, "Teleporting...")
            teleport()
        }
    }

    public func teleport() {
        guard let subject else { return }
        let worldWidth = subject.worldBounds.width
        let randomX = worldWidth * CGFloat.random(in: 0.2 ... 0.8)
        subject.frame.origin = CGPoint(x: randomX, y: 30)
        subject.direction = CGVector(dx: 1, dy: 0)
        subject.set(state: .move)
    }

    func outerBounds() -> CGRect {
        (subject?.worldBounds.bounds ?? .zero).inset(by: -boundsThickness)
    }

    func isWithinBounds(point: CGPoint) -> Bool {
        let bounds = outerBounds()
        if bounds.contains(point) { return true }
        Logger.log(tag, subject?.id ?? "", "at", point.description, "is outside", bounds.description)
        return false
    }
}
