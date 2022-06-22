//
// Pet Therapy.
//

import Foundation
import Biosphere

// MARK: - Species

extension Pet {
    
    static let ufo = Pet(
        id: "ufo",
        capabilities: .defaultsNoGravity,
        movementPath: .idleFront,
        dragPath: .idleFront,
        speed: 2.4
    )
}
    
// MARK: - Ufo Entity

public class UfoEntity: PetEntity {
    
    public init(size: CGSize? = nil, in habitatBounds: CGRect) {
        super.init(of: .ufo, size: size, in: habitatBounds, installCapabilities: true)
    }
    
    public func abduct(_ target: Entity) {
        let abduction = install(UfoAbduction.self)
        uninstall(BounceOffLateralBounds.self)
        uninstall(ReactToHotspots.self)
        uninstall(ResumeMovementAfterAnimations.self)
        abduction.abduct(target) {
            self.install(BounceOffLateralBounds.self)
            self.install(ReactToHotspots.self)
            self.install(ResumeMovementAfterAnimations.self)
        }
    }
}

// MARK: - Animations

private extension EntityAnimation {
    
    static let abduction = EntityAnimation(
        id: "abduction",
        size: CGSize(width: 1, height: 3),
        position: .entityTopLeft
    )
}

// MARK: - Abduction

private class UfoAbduction: Capability {
    
    weak var target: Entity?
        
    private var onCompletion: () -> Void = {}
    
    func abduct(_ target: Entity, onCompletion: @escaping () -> Void) {
        self.target = target
        self.onCompletion = onCompletion
        followTargetUntilCaptured()
    }
    
    private func followTargetUntilCaptured() {
        guard let body = subject, let target = target else { return }
        let seeker = body.install(Seeker.self)
        seeker.follow(
            target,
            to: .above,
            offset: .init(width: 0, height: -50)
        ) { captureState in
            guard case .captured = captureState else { return }
            seeker.isEnabled = false
            self.captureRayAnimation()
        }
    }
    
    private func captureRayAnimation() {
        guard let target = target else { return }
        subject?.set(direction: .zero)
        subject?.set(state: .animation(animation: .abduction))
        
        target.uninstall(Gravity.self)
        target.set(direction: CGVector(dx: 0, dy: -1))
        target.speed = PetEntity.speedMultiplier(for: target.frame.size.width)
        
        let shape = target.install(ShapeShifter.self)
        shape.scaleLinearly(to: CGSize(width: 5, height: 5), duracy: 1.1)
        scheduleAnimationCompletion(in: 1.25)
    }
    
    private func scheduleAnimationCompletion(in delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.target?.uninstall(AnimatedSprite.self)
            self.resumeMovement()
        }
    }
    
    private func resumeMovement() {
        guard let pet = subject as? PetEntity else { return }
        pet.set(state: .move)
        pet.set(direction: CGVector(dx: 1, dy: 0))
        pet.speed = PetEntity.speed(for: pet.species, size: pet.frame.width)
        pet.uninstall(UfoAbduction.self)
        pet.uninstall(Seeker.self)
        onCompletion()
    }
    
    override func uninstall() {
        super.uninstall()
        self.onCompletion = {}
        self.target = nil
    }
}
