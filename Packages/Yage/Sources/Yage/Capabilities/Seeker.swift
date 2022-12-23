import Schwifty
import SwiftUI

public class Seeker: Capability {
    private weak var targetEntity: Entity?
    private var targetPosition: Position = .center
    private var targetOffset: CGSize = .zero
    private var autoAdjustSpeed: Bool = true
    private var minDistance: CGFloat = 5
    private var maxDistance: CGFloat = 20
    private var baseSpeed: CGFloat = 0
    private var targetReached: Bool = false
    private var report: (State) -> Void = { _ in }

    public required init(for subject: Entity) {
        super.init(for: subject)
        baseSpeed = subject.speed
    }

    // MARK: - Follow

    public func follow(
        _ target: Entity,
        to position: Position,
        offset: CGSize = .zero,
        autoAdjustSpeed: Bool = true,
        minDistance: CGFloat = 5,
        maxDistance: CGFloat = 20,
        report: @escaping (State) -> Void
    ) {
        targetEntity = target
        targetPosition = position
        targetOffset = offset
        self.autoAdjustSpeed = autoAdjustSpeed
        self.minDistance = minDistance
        self.maxDistance = maxDistance
        self.report = report
    }

    // MARK: - Update

    override public func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let subject else { return }
        guard let target = targetPoint() else { return }

        let distance = subject.frame.origin.distance(from: target)
        checkTargetReached(with: distance)
        adjustSpeedIfNeeded(with: distance)
        adjustDirection(towards: target, with: distance)
    }

    // MARK: - Destination Reached

    private func checkTargetReached(with distance: CGFloat) {
        if !targetReached {
            if distance <= minDistance {
                targetReached = true
                report(.captured)
            } else {
                report(.following(distance: distance))
            }
        } else if distance >= maxDistance && targetReached {
            targetReached = false
            report(.escaped)
        }
    }

    // MARK: - Direction

    private func adjustDirection(towards target: CGPoint, with distance: CGFloat) {
        guard let subject else { return }
        if distance < minDistance {
            subject.direction = .zero
        } else {
            subject.direction = .unit(from: subject.frame.origin, to: target)
        }
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
        guard let targetFrame = targetEntity?.frame else { return nil }

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
        targetEntity = nil
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
    enum State: CustomStringConvertible {
        case captured
        case escaped
        case following(distance: CGFloat)

        public var description: String {
            switch self {
            case .captured: return "Captured"
            case .escaped: return "Escaped"
            case .following(let distance):
                return "Following... \(String(format: "%0.2f", distance))"
            }
        }
    }
}
