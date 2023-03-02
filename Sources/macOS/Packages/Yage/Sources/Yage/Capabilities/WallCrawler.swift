import SwiftUI

public class WallCrawler: Capability {
    public override func install(on subject: Entity) {
        super.install(on: subject)
        subject.capability(for: BounceOnLateralCollisions.self)?.isEnabled = false
        subject.capability(for: FlipHorizontallyWhenGoingLeft.self)?.isEnabled = false
    }

    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard case .move = subject?.state else { return }
        guard let direction = subject?.direction else { return }

        let isGoingUp = direction.dy < -0.0001
        let isGoingRight = direction.dx > 0.0001
        let isGoingDown = direction.dy > 0.0001
        let isGoingLeft = direction.dx < -0.0001

        if isGoingUp && touchesScreenTop() {
            crawlAlongTopBound()
            return
        }
        if isGoingRight && touchesScreenRight() {
            crawlUpRightBound()
            return
        }
        if isGoingDown && touchesScreenBottom() {
            crawlAlongBottomBound()
            return
        }
        if isGoingLeft && touchesScreenLeft() {
            crawlDownLeftBound()
            return
        }
    }

    private func crawlAlongTopBound() {
        guard let subject else { return }
        subject.direction = .init(dx: -1, dy: 0)
        subject.frame.origin = CGPoint(x: subject.frame.origin.x, y: 0)
        subject.rotation?.isFlippedHorizontally = true
        subject.rotation?.isFlippedVertically = true
        subject.rotation?.zAngle = 0
    }

    private func crawlUpRightBound() {
        guard let subject else { return }
        subject.direction = .init(dx: 0, dy: -1)
        subject.frame.origin = CGPoint(
            x: subject.worldBounds.width - subject.frame.width,
            y: subject.frame.origin.y
        )
        subject.rotation?.isFlippedHorizontally = false
        subject.rotation?.isFlippedVertically = false
        subject.rotation?.zAngle = .pi * 0.5
    }

    private func crawlAlongBottomBound() {
        guard let subject else { return }
        subject.direction = .init(dx: 1, dy: 0)
        subject.frame.origin = CGPoint(
            x: subject.frame.origin.x,
            y: subject.worldBounds.height - subject.frame.height
        )
        subject.rotation?.isFlippedHorizontally = false
        subject.rotation?.isFlippedVertically = false
        subject.rotation?.zAngle = 0
    }

    private func crawlDownLeftBound() {
        guard let subject else { return }
        subject.direction = .init(dx: 0, dy: 1)
        subject.frame.origin = CGPoint(x: 0, y: subject.frame.origin.y)
        subject.rotation?.isFlippedHorizontally = false
        subject.rotation?.isFlippedVertically = false
        subject.rotation?.zAngle = .pi * 1.5
    }

    private func touchesScreenTop() -> Bool {
        guard let subject else { return false }
        return subject.frame.minY <= 0
    }

    private func touchesScreenRight() -> Bool {
        guard let subject else { return false }
        let bound = subject.worldBounds.width
        return subject.frame.maxX >= bound
    }

    private func touchesScreenBottom() -> Bool {
        guard let subject else { return false }
        let bound = subject.worldBounds.height
        return subject.frame.maxY >= bound
    }

    private func touchesScreenLeft() -> Bool {
        guard let subject else { return false }
        return subject.frame.minX <= 0
    }
}
