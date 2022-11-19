import Pets
import SwiftUI
import Schwifty
import Yage

protocol JumperPlatformsProvider {
    func platforms() -> [Entity]
}

class RandomPlatformJumper: Capability {
    static func compatible(with pet: PetEntity) -> Bool {
        pet.species.movementPath == .fly
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
        let delay = TimeInterval.random(in: 30...120)
        scheduleJump(after: delay)
        printDebug(tag, "Scheduled jump in \(delay)")
    }
    
    private func scheduleJump(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
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
            printDebug(tag, "Can't jump, no platform found")
        }
    }
    
    private func jump(to target: Entity) {
        guard let subject = subject else { return }
        printDebug(tag, "Jumping to \(target.id)", target.frame.description)
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

