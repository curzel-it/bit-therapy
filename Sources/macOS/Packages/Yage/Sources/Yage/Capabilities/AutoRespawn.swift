import Combine
import Schwifty
import SwiftUI

public class AutoRespawn: Capability {
    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard let subject, subject.state != .drag else { return }
        if !isWithinBounds(point: subject.frame.origin) {
            Logger.log(tag, subject.id, "Teleporting...")
            teleport()
        }
    }

    public func teleport() {
        guard let subject else { return }
        let worldWidth = subject.worldBounds.width
        let randomX = worldWidth * CGFloat.random(in: 0.05...0.95)
        subject.frame.origin = CGPoint(x: randomX, y: 30)
        subject.direction = CGVector(dx: 1, dy: 0)
        subject.set(state: .move)
    }

    func outerBounds() -> CGRect {
        (subject?.worldBounds.bounds ?? .zero).inset(by: -boundsThickness*5)
    }

    func isWithinBounds(point: CGPoint) -> Bool {
        let bounds = outerBounds()
        if bounds.contains(point) { return true }
        Logger.log(tag, subject?.id ?? "", "at", point.description, "is outside", bounds.description)
        return false
    }
}
