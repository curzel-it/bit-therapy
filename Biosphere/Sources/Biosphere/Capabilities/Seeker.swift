//
// Pet Therapy.
//

import SwiftUI

open class Seeker: Capability {
    
    private weak var targetEntity: Entity?
    private var targetPosition: Position = .center
    private var tolerance: CGFloat = 5
    
    private let baseSpeed: CGFloat
    
    public required init(with body: Entity) {
        baseSpeed = body.speed
        super.init(with: body)
    }
    
    public func follow(_ target: Entity, to position: Position, tolerance: CGFloat = 5) {
        self.targetEntity = target
        self.targetPosition = position
        self.tolerance = tolerance
    }
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let body = body else { return }
        guard let target = targetPoint() else { return }
        
        let distance = body.frame.origin.distance(from: target)
        adjustSpeed(given: distance)
        
        if distance < tolerance {
            body.set(direction: .zero)
        } else {
            body.set(direction: .unit(from: body.frame.origin, to: target))
        }
    }
    
    private func adjustSpeed(given distance: CGFloat) {
        switch true {
        case distance < tolerance * 4: body?.speed = baseSpeed * 0.3
        case distance < tolerance * 2: body?.speed = baseSpeed * 0.1
        default: body?.speed = baseSpeed
        }
    }
    
    private func targetPoint() -> CGPoint? {
        guard let frame = body?.frame else { return nil }
        guard let targetFrame = targetEntity?.frame else { return nil }
        
        let centerX = targetFrame.minX + targetFrame.width/2 - frame.width/2
        
        switch targetPosition {
        case .center:
            return CGPoint(
                x: centerX,
                y: targetFrame.minY + targetFrame.height/2 - frame.height/2
            )
        case .above:
            return CGPoint(
                x: centerX,
                y: targetFrame.minY - frame.height
            )
        }
    }
}

extension Seeker {
    
    public enum Position {
        case center
        case above
    }
}
