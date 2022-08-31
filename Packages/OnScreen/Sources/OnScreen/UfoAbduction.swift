import AppState
import DesktopKit
import Foundation
import Pets

// MARK: - Schedule Event

extension ViewModel {
    
    @discardableResult
    func scheduleUfoAbduction() -> Event {        
        return state.schedule(every: .timeOfDay(hour: 22, minute: 30)) { [weak self] _ in
            guard let victim = self?.victim else { return }
            self?.animateUfoAbduction(of: victim)
        }
    }
}

// MARK: - Play Event

private extension ViewModel {
    
    var victim: Entity? {
        state.children
            .filter { $0 is DesktopPet }
            .randomElement()
    }
    
    func animateUfoAbduction(of target: Entity) {
        let ufo = UfoEntity(in: state.bounds)
        ufo.set(origin: state.bounds.topLeft.offset(x: -100, y: -100))
        state.children.append(ufo)
        ufo.abduct(target, onCompletion: respawn)
    }
    
    func respawn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            OnScreen.show()
        }
    }
}

// MARK: - Entity

private class UfoEntity: PetEntity {
    
    init(in habitatBounds: CGRect) {
        super.init(
            of: .ufo,
            size: AppState.global.petSize,
            in: habitatBounds,
            installCapabilities: true
        )
        uninstall(BounceOffLateralCollisions.self)
        uninstall(RandomAnimations.self)
        uninstall(ReactToHotspots.self)
    }
    
    func abduct(_ target: Entity, onCompletion: @escaping () -> Void) {
        let abduction = install(UfoAbduction.self)
        abduction.abduct(target, onCompletion)
    }
}

// MARK: - Animation

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
    
    private var subjectOriginalSize: CGSize!
        
    private var onCompletion: () -> Void = {}
    
    func abduct(_ target: Entity, _ onCompletion: @escaping () -> Void) {
        guard let body = subject else { return }
        self.subjectOriginalSize = body.frame.size
        self.target = target
        self.onCompletion = onCompletion
        
        let seeker = body.install(Seeker.self)
        let distance = CGSize(width: 0, height: -50)
        
        seeker.follow(target, to: .above, offset: distance) { captureState in
            guard case .captured = captureState else { return }
            seeker.isEnabled = false
            self.paralizeTarget()
            self.captureRayAnimation()
        }
    }
    
    private func paralizeTarget() {
        target?.uninstall(Gravity.self)
        target?.set(direction: CGVector(dx: 0, dy: -1))
        target?.speed = PetEntity.speedMultiplier(for: target?.frame.size.width ?? 0)
    }
    
    private func captureRayAnimation() {
        subject?.set(direction: .zero)
        subject?.set(state: .animation(animation: .abduction, loops: 1))
        subject?.uninstall(Seeker.self)
        
        let shape = target?.install(ShapeShifter.self)
        shape?.scaleLinearly(to: CGSize(width: 5, height: 5), duracy: 1.1)
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
        pet.set(size: subjectOriginalSize)
        pet.set(direction: CGVector(dx: 1, dy: 0))
        pet.speed = PetEntity.speed(for: pet.species, size: pet.frame.width)
        pet.uninstall(UfoAbduction.self)
        onCompletion()
    }
    
    override func kill() {
        super.kill()
        self.onCompletion = {}
        self.target = nil
    }
}
