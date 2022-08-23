//
// Pet Therapy.
//

import Squanch
import SwiftUI

open class Seeker: Capability {
    
    private weak var targetEntity: Entity?
    private var targetPosition: Position = .center
    private var targetOffset: CGSize = .zero
    private var minDistance: CGFloat = 5
    private var maxDistance: CGFloat = 20
    
    private let baseSpeed: CGFloat
    private var targetReached: Bool = false

    private var report: (State) -> Void = { _ in }
    
    public required init(with subject: Entity) {
        baseSpeed = subject.speed
        super.init(with: subject)
    }
    
    // MARK: - Follow
    
    public func follow(
        _ target: Entity,
        to position: Position,
        offset: CGSize = .zero,
        minDistance: CGFloat = 5,
        maxDistance: CGFloat = 20,
        report: @escaping (State) -> Void
    ) {
        self.targetEntity = target
        self.targetPosition = position
        self.targetOffset = offset
        self.minDistance = minDistance
        self.maxDistance = maxDistance
        self.report = report
    }
    
    // MARK: - Update
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let body = subject else { return }
        guard let target = targetPoint() else { return }

        let distance = body.frame.origin.distance(from: target)
        checkTargetReached(with: distance)
        adjustSpeed(with: distance)
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
        if distance < minDistance {
            subject?.set(direction: .zero)
        } else {
            let origin = subject?.frame.origin ?? .zero
            subject?.set(direction: .unit(from: origin, to: target))
        }
    }
    
    // MARK: - Speed
    
    private func adjustSpeed(with distance: CGFloat) {
        if distance < minDistance {
            subject?.speed = baseSpeed * 0.25
        } else if distance < maxDistance {
            subject?.speed = baseSpeed * 0.5
        }
    }
    
    // MARK: - Target Location
    
    private func targetPoint() -> CGPoint? {
        guard let frame = subject?.frame else { return nil }
        guard let targetFrame = targetEntity?.frame else { return nil }
        
        let centerX = targetFrame.minX + targetFrame.width/2 - frame.width/2
        let centerY = targetFrame.minY + targetFrame.height/2 - frame.height/2
        
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
    
    override open func uninstall() {
        super.uninstall()
        targetEntity = nil
        report = { _ in }
    }
}

extension Seeker {
    
    public enum Position {
        case center
        case above
    }
}

extension Seeker {
    
    public enum State: CustomStringConvertible {
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
