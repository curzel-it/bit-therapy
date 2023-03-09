import Foundation
import Yage

// MARK: - Schedule Event

extension ScreenEnvironment {
    func scheduleUfoAbduction() {
        scheduleRandomly(withinHours: 0..<5) { [weak self] in
            guard let self else { return }
            guard self.settings.randomEvents else { return }
            self.scheduleUfoAbductionNow()
        }
    }
    
    private func scheduleUfoAbductionNow() {
        guard let victim = randomPet() else { return }
        let victimSpecies = victim.species        
        ufoAbductionUseCase.start(with: victim, in: self) { [weak self] in
            self?.add(pet: victimSpecies)
        }
    }
}

protocol UfoAbductionUseCase {
    func start(with target: Entity, in world: World, completion: @escaping () -> Void)
}

class UfoAbductionUseCaseImpl: UfoAbductionUseCase {
    @Inject private var settings: AppConfig
    
    func start(with target: Entity, in world: World, completion: @escaping () -> Void) {
        let ufo = buildUfo(in: world)
        let abduction = ufo.capability(for: UfoAbduction.self)
        abduction?.start(with: target) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self, weak world] in
                guard let self, let world else { return }
                self.cleanUpAfterAbduction(of: target, by: ufo, in: world, completion: completion)
            }
        }
    }
    
    private func cleanUpAfterAbduction(
        of target: Entity,
        by ufo: Entity,
        in world: World,
        completion: @escaping () -> Void
    ) {
        ufo.kill()
        target.kill()
        world.children.remove(ufo)
        world.children.remove(target)
        completion()
    }

    private func buildUfo(in world: World) -> Entity {
        let ufo = PetEntity(of: .ufo, in: world)
        ufo.frame.origin = world.bounds.topLeft
        ufo.isEphemeral = true
        ufo.install(UfoAbduction())
        world.children.append(ufo)
        return ufo
    }
}

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
    
    func start(with target: Entity, onCompletion: @escaping () -> Void) {
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
