import Pets
import Schwifty
import SwiftUI
import Yage

// MARK: - Platform Jumper

class RandomPlatformJumper: Capability {
    static func compatible(with species: Entity) -> Bool {
        species.species.movementPath == "fly"
    }

    private var lastPlatformId: String?
    private var platformsProvider: JumperPlatformsProvider!

    private var gravity: Gravity? {
        subject?.capability(for: Gravity.self)
    }

    private var seeker: Seeker? {
        subject?.capability(for: Seeker.self)
    }

    private var animations: RandomAnimations? {
        subject?.capability(for: RandomAnimations.self)
    }

    public func start(with platformsProvider: JumperPlatformsProvider) {
        self.platformsProvider = platformsProvider
        scheduleJumpAfterRandomInterval()
    }

    private func scheduleJumpAfterRandomInterval() {
        let delay = TimeInterval.random(in: 30 ... 120)
        scheduleJump(after: delay)
        Logger.log(tag, "Scheduled jump in \(delay)")
    }

    private func scheduleJump(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            self.scheduleJumpAfterRandomInterval()
            guard self.isEnabled && self.subject?.isAlive == true else { return }
            self.jump()
            self.isEnabled = false
        }
    }

    private func jump() {
        if let target = findPlatform() {
            jump(to: target)
        } else {
            Logger.log(tag, "Can't jump, no platform found")
        }
    }

    private func jump(to target: Entity) {
        guard let subject = subject else { return }
        Logger.log(tag, "Jumping to \(target.id)", target.frame.description)
        lastPlatformId = target.id
        gravity?.isEnabled = false
        animations?.isEnabled = false

        let seeker = Seeker.install(on: subject)
        seeker.follow(target, to: .above, autoAdjustSpeed: false) { [weak self] captureState in
            guard case .captured = captureState else { return }
            self?.restoreInitialConditions()
            self?.animations?.animateNow()
        }
    }

    private func findPlatform() -> Entity? {
        platformsProvider
            .platforms()
            .filter { $0.id != lastPlatformId }
            .randomElement()
    }

    private func restoreInitialConditions() {
        isEnabled = true
        seeker?.kill()
        gravity?.isEnabled = true
        animations?.isEnabled = true
        subject?.direction = CGVector(dx: 1, dy: 0)
    }

    override func kill(autoremove: Bool = true) {
        restoreInitialConditions()
        super.kill(autoremove: autoremove)
    }
}

// MARK: - Entity Extension

extension Entity {
    func setupJumperIfPossible(with platforms: JumperPlatformsProvider?) {
        guard let platforms = platforms else { return }
        guard RandomPlatformJumper.compatible(with: self) else { return }
        let jumper = RandomPlatformJumper.install(on: self)
        jumper.start(with: platforms)
    }
}

// MARK: - Platforms Provider

protocol JumperPlatformsProvider {
    func platforms() -> [Entity]
}

extension DesktopObstaclesService: JumperPlatformsProvider {
    func platforms() -> [Entity] {
        world.children.filter {
            $0.isWindowObstacle || $0.id == Hotspot.bottomBound.rawValue
        }
    }
}
