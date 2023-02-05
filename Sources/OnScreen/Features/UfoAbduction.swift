import Foundation
import Yage

// MARK: - Schedule Event

extension ScreenEnvironment {
    func scheduleUfoAbduction() {
        scheduleRandomly(withinHours: 0..<5) { [weak self] in
            guard AppState.global.randomEvents else { return }
            guard let self, let victim = self.randomVictim() else { return }
            self.animateUfoAbduction(of: victim)
        }
    }
}

private extension ScreenEnvironment {
    func randomVictim() -> PetEntity? {
        children
            .compactMap { $0 as? PetEntity }
            .randomElement()
    }
    
    func animateUfoAbduction(of target: PetEntity) {
        let ufo = UfoEntity(in: self)
        children.append(ufo)
        ufo.abduct(target) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.cleanUpAfterAbduction(of: target, by: ufo)
            }
        }
    }
    
    private func cleanUpAfterAbduction(of target: PetEntity, by ufo: PetEntity) {
        ufo.kill()
        target.kill()
        children.remove(ufo)
        children.remove(target)
        add(pet: target.species)
    }
}

// MARK: - Entity

private class UfoEntity: PetEntity {
    init(in world: World) {
        super.init(of: .ufo, in: world)
        frame.origin = world.bounds.topLeft
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
    private weak var target: Entity?
    private var subjectOriginalSize: CGSize!
    private var onCompletion: () -> Void = {}
    
    func abduct(_ target: Entity, _ onCompletion: @escaping () -> Void) {
        guard let subject else { return }
        subjectOriginalSize = subject.frame.size
        self.target = target
        self.onCompletion = onCompletion
        
        let seeker = Seeker()
        subject.install(seeker)
        let distance = CGSize(width: 0, height: -50)
        
        seeker.follow(target, to: .above, offset: distance) { [weak self] captureState in
            guard let self else {
                seeker.kill()
                onCompletion()
                return
            }
            guard case .captured = captureState else { return }
            seeker.isEnabled = false
            self.paralizeTarget()
            self.captureRayAnimation()
        }
    }
    
    private func paralizeTarget() {
        guard let target else { return }
        target.setGravity(enabled: false)
        target.direction = CGVector(dx: 0, dy: -1)
        target.speed = 1.2 * PetEntity.speedMultiplier(for: target.frame.size.width)
    }
    
    private func captureRayAnimation() {
        guard let subject, let target else { return }
        subject.direction = .zero
        subject.set(state: .action(action: .abduction, loops: 1))
        subject.capability(for: Seeker.self)?.kill()
        
        let shape = ShapeShifter()
        target.install(shape)
        shape.scaleLinearly(to: CGSize(width: 5, height: 5), duracy: 1.1)
        scheduleCompletion(in: 1.25)
    }
    
    private func scheduleCompletion(in delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.animationCompleted()
        }
    }
    
    private func animationCompleted() {
        guard let target, let subject else { return }
        target.kill()
        subject.setGravity(enabled: false)
        subject.direction = CGVector(dx: 1, dy: -1)
        subject.set(state: .move)
        subject.movement?.isEnabled = true
        subject.frame.size = subjectOriginalSize
        onCompletion()
        kill()
    }
    
    override func kill(autoremove: Bool = true) {
        target = nil
        onCompletion = {}
        super.kill()
    }
}

private extension Species {
    static let ufo = Species(
        id: "ufo",
        capabilities: [
            "AnimatedSprite",
            "AnimationsProvider",
            "LinearMovement",
            "PetsSpritesProvider"
        ],
        dragPath: "front",
        movementPath: "front",
        speed: 2
    )
}
