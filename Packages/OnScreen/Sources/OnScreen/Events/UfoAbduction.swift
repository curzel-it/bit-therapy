import AppState
import Foundation
import Pets
import Yage

// MARK: - Schedule Event

extension ViewModel {
    func scheduleUfoAbduction() {
        let settingsInterval = EventSchedule.from(string: AppState.global.ufoAbductionSchedule)
        let actualInterval = settingsInterval ?? .timeOfDay(hour: 22, minute: 30)
        state.schedule(every: actualInterval) { [weak self] _ in
            self?.startUfoAbductionOfRandomVictim()
        }
    }
    
    func startUfoAbductionOfRandomVictim() {
        guard let victim = victim else { return }
        animateUfoAbduction(of: victim)
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
        ufo.abduct(target) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                OnScreen.show()
            }
        }
    }
}

// MARK: - Entity

private class UfoEntity: PetEntity {
    init(in worldBounds: CGRect) {
        super.init(
            of: .ufo,
            size: AppState.global.petSize,
            in: worldBounds,
            settings: AppState.global
        )
        setBounceOnLateralCollisions(enabled: false)
        uninstall(RandomAnimations.self)
        uninstall(ReactToHotspots.self)
    }
    
    func abduct(_ target: Entity, onCompletion: @escaping () -> Void) {
        let abduction = UfoAbduction()
        install(abduction)
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
        
        let seeker = Seeker()
        body.install(seeker)
        let distance = CGSize(width: 0, height: -50)
        
        seeker.follow(target, to: .above, offset: distance) { captureState in
            guard case .captured = captureState else { return }
            seeker.isEnabled = false
            self.paralizeTarget()
            self.captureRayAnimation()
        }
    }
    
    private func paralizeTarget() {
        target?.setGravity(enabled: false)
        target?.set(direction: CGVector(dx: 0, dy: -1))
        target?.speed = PetEntity.speedMultiplier(for: target?.frame.size.width ?? 0)
    }
    
    private func captureRayAnimation() {
        subject?.set(direction: .zero)
        subject?.set(state: .action(action: EntityAnimation.abduction, loops: 1))
        subject?.uninstall(Seeker.self)
                
        let shape = ShapeShifter()
        target?.install(shape)
        shape.scaleLinearly(to: CGSize(width: 5, height: 5), duracy: 1.1)
        scheduleAnimationCompletion(in: 1.25)
    }
    
    private func scheduleAnimationCompletion(in delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.target?.uninstall(AnimatedSprite.self)
            self.resumeMovement()
            self.onCompletion()
        }
    }
    
    private func resumeMovement() {
        guard let pet = subject as? PetEntity else { return }
        pet.set(state: .move)
        pet.set(size: subjectOriginalSize)
        pet.set(direction: CGVector(dx: 1, dy: 0))
        pet.uninstall(UfoAbduction.self)
    }
    
    override func kill() {
        super.kill()
        self.target = nil
    }
}
