import Foundation
import Yage

// MARK: - Schedule Event

extension ScreenEnvironment {
    func scheduleRainyCloud() {
        scheduleRandomly(withinHours: 0..<5) { [weak self] in
            guard AppState.global.randomEvents else { return }
            guard let self, let victim = self.randomPet() else { return }
            self.animateRainyCloud(of: victim)
        }
    }
}

// MARK: - Logic

private extension ScreenEnvironment {
    func animateRainyCloud(of target: PetEntity) {
        let cloud = buildCloud(at: target.frame.origin)
        setupSeeker(for: cloud, to: target)
        scheduleCleanUp(cloud: cloud)
    }
    
    func buildCloud(at origin: CGPoint) -> Entity {
        let cloud = PetEntity(of: .cloud, in: self)
        cloud.capability(for: Gravity.self)?.kill()
        cloud.frame.size = CGSize(
            width: cloud.frame.size.width * 2,
            height: cloud.frame.size.height * 2
        )
        cloud.frame.origin = origin
        cloud.isEphemeral = true
        children.append(cloud)
        return cloud
    }
    
    func setupSeeker(for cloud: Entity, to target: Entity) {
        let yOffset = cloud.frame.height - target.frame.height
        let seeker = Seeker()
        cloud.install(seeker)
        seeker.follow(
            target,
            to: .above,
            offset: CGSize(width: 0, height: yOffset),
            autoAdjustSpeed: true
        ) { _ in }
    }
    
    func scheduleCleanUp(cloud: Entity) {
        let duracy = TimeInterval.random(in: 60..<120)
        DispatchQueue.main.asyncAfter(deadline: .now() + duracy) { [weak self] in
            cloud.kill()
            self?.children.remove(cloud)
        }
    }
}

// MARK: - Species

private extension Species {
    static let cloud = Species(
        id: "fantozzi",
        capabilities: [
            "AnimatedSprite",
            "AnimationsProvider",
            "LinearMovement",
            "PetsSpritesProvider"
        ],
        dragPath: "front",
        movementPath: "front",
        speed: 2,
        zIndex: 200
    )
}
