//
// Pet Therapy.
//

import AppState
import Biosphere
import Foundation
import Pets

// MARK: - Event

public func animateUfoAbduction(
    of target: Entity,
    in env: Environment,
    onCompletion: @escaping () -> Void
) {
    let ufo = UfoEntity(in: env.bounds)
    ufo.set(origin: env.bounds.topLeft.offset(x: -100, y: -100))
    env.children.append(ufo)
    ufo.abduct(target, onCompletion)
}

// MARK: - Entity

class UfoEntity: PetEntity {
    
    init(in habitatBounds: CGRect) {
        super.init(
            of: .ufo,
            size: AppState.global.petSize,
            in: habitatBounds,
            installCapabilities: true
        )
    }
    
    func abduct(_ target: Entity, _ onCompletion: @escaping () -> Void) {
        uninstall(BounceOffLateralBounds.self)
        uninstall(ReactToHotspots.self)
        
        let abduction = install(UfoAbduction.self)
        
        abduction.abduct(target) {
            self.install(BounceOffLateralBounds.self)
            self.install(ReactToHotspots.self)
            onCompletion()
        }
    }
}

// MARK: - Animation

extension EntityAnimation {
    
    fileprivate static let abduction = EntityAnimation(
        id: "abduction",
        size: CGSize(width: 1, height: 3),
        position: .entityTopLeft
    )
}

// MARK: - Abduction

private class UfoAbduction: Capability {
    
    weak var target: Entity?
        
    private var onCompletion: () -> Void = {}
    
    func abduct(_ target: Entity, _ onCompletion: @escaping () -> Void) {
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
        subject?.set(state: .animation(animation: .abduction, loops: 1))
        subject?.uninstall(Seeker.self)
        
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
        onCompletion()
        pet.uninstall(UfoAbduction.self)
    }
    
    override func uninstall() {
        super.uninstall()
        self.onCompletion = {}
        self.target = nil
    }
}
