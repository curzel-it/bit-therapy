import Schwifty
import SwiftUI

public protocol SeekerTarget {
    var frame: CGRect { get }
}

extension Entity: SeekerTarget {}

public class Seeker: Capability {
    private var target: SeekerTarget?
    private var targetPosition: Position = .center
    private var targetOffset: CGSize = .zero
    private var autoAdjustSpeed: Bool = true
    private var minDistance: CGFloat = 5
    private var maxDistance: CGFloat = 20
    private var baseSpeed: CGFloat = 0
    private var targetReached: Bool = false
    private var report: (State) -> Void = { _ in }

    public override func install(on subject: Entity) {
        super.install(on: subject)
        baseSpeed = subject.speed
    }

    // MARK: - Follow

    public func follow(
        _ target: SeekerTarget,
        to position: Position,
        offset: CGSize = .zero,
        autoAdjustSpeed: Bool = true,
        minDistance: CGFloat = 5,
        maxDistance: CGFloat = 20,
        report: @escaping (State) -> Void = { _ in }
    ) {
        self.autoAdjustSpeed = autoAdjustSpeed
        self.minDistance = minDistance
        self.maxDistance = maxDistance
        self.report = report
        self.target = target
        self.targetOffset = offset
        self.targetPosition = position
    }

    // MARK: - Update

    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard let subject else { return }
        guard let target = targetPoint() else { return }
        let totalDistance = subject.frame.origin.distance(from: target)
        let horizontalDistance = abs(subject.frame.origin.x - target.x)
        let distance = canFly ? totalDistance : horizontalDistance
        
        checkTargetReached(with: distance, horizontally: horizontalDistance)
        adjustSpeedIfNeeded(with: distance)
        adjustDirection(towards: target, with: distance)
    }

    // MARK: - Destination Reached

    private func checkTargetReached(
        with distance: CGFloat,
        horizontally horizontalDistance: CGFloat
    ) {
        if !targetReached {
            if distance <= minDistance {
                targetReached = true
                report(.captured)
            } else {
                let state = Seeker.State.following(
                    distance: distance,
                    horizontally: horizontalDistance
                )
                report(state)
            }
        } else if distance >= maxDistance && targetReached {
            targetReached = false
            report(.escaped)
        }
    }

    // MARK: - Direction
    
    private func adjustDirection(towards target: CGPoint, with distance: CGFloat) {
        guard let subject else { return }
        let direction = linearDirection(towards: target, with: distance)
        if canFly {
            subject.direction = direction
        } else {
            subject.direction = CGVector(
                dx: direction.dx == 0 ? 0 : (target.x < subject.frame.origin.x ? -1 : 1),
                dy: max(direction.dy, 0, subject.direction.dy)
            )
        }
    }
    
    private func linearDirection(towards target: CGPoint, with distance: CGFloat) -> CGVector {
        guard let subject else { return .zero }
        if distance < minDistance {
            return .zero
        } else {
            return .unit(from: subject.frame.origin, to: target)
        }
    }
    
    private var canFly: Bool {
        let gravity = subject?.capability(for: Gravity.self)
        if gravity == nil || gravity?.isEnabled == false { return true }
        return false
    }

    // MARK: - Speed

    private func adjustSpeedIfNeeded(with distance: CGFloat) {
        guard let subject, autoAdjustSpeed else { return }
        if distance < minDistance {
            subject.speed = baseSpeed * 0.25
        } else if distance < maxDistance {
            subject.speed = baseSpeed * 0.5
        } else {
            subject.speed = baseSpeed
        }
    }

    // MARK: - Target Location

    private func targetPoint() -> CGPoint? {
        guard let frame = subject?.frame else { return nil }
        guard let targetFrame = target?.frame else { return nil }

        let centerX = targetFrame.minX + targetFrame.width / 2 - frame.width / 2
        let centerY = targetFrame.minY + targetFrame.height / 2 - frame.height / 2

        switch targetPosition {
        case .center:
            return CGPoint(
                x: centerX + targetOffset.width,
                y: centerY + targetOffset.height
            )
        case .above:
            return CGPoint(
                x: centerX + targetOffset.width,
                y: targetFrame.minY - frame.height + targetOffset.height
            )
        }
    }

    // MARK: - Uninstall

    override public func kill(autoremove: Bool = true) {
        target = nil
        report = { _ in }
        super.kill(autoremove: autoremove)
    }
}

public extension Seeker {
    enum Position {
        case center
        case above
    }
}

public extension Seeker {
    enum State: Equatable, CustomStringConvertible {
        case captured
        case escaped
        case following(distance: CGFloat, horizontally: CGFloat)

        public var description: String {
            switch self {
            case .captured: return "Captured"
            case .escaped: return "Escaped"
            case .following(let distance, _):
                return "Following... \(String(format: "%0.2f", distance))"
            }
        }
    }
}
