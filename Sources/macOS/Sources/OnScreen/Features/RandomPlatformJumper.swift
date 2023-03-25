import Schwifty
import SwiftUI
import Yage

class RandomPlatformJumper: Capability {
    private var animations: AnimationsScheduler? { subject?.capability(for: AnimationsScheduler.self) }
    private var gravity: Gravity? { subject?.capability(for: Gravity.self) }
    private var lastPlatformId: String?
    private var scheduledJumpDate: Date?
    private var seeker: Seeker? { subject?.capability(for: Seeker.self) }
    
    private lazy var includeBottomBound: Bool = {
        DeviceRequirement.macOS.isSatisfied
    }()
    
    override func install(on subject: Entity) {
        super.install(on: subject)
        DispatchQueue.main.async { [weak self] in
            self?.scheduleJumpAfterRandomInterval()
        }
    }
    
    private func scheduleJumpAfterRandomInterval() {
        let delay = TimeInterval.random(in: 20...90)
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
        guard isEnabled else { return }
        if let target = findPlatform() {
            jump(to: target)
        } else {
            Logger.log(tag, "Can't jump, no platform found")
        }
    }
    
    private func jump(to target: Entity) {
        guard let subject else { return }
        Logger.log(tag, "Jumping to \(target.id)", target.frame.description)
        lastPlatformId = target.id
        gravity?.isEnabled = false
        animations?.isEnabled = false
        
        let seeker = Seeker()
        subject.install(seeker)
        seeker.follow(target, to: .above, autoAdjustSpeed: false) { [weak self] captureState in
            guard case .captured = captureState else { return }
            self?.restoreInitialConditions()
            self?.animations?.animateNow()
        }
    }
    
    private func findPlatform() -> Entity? {
        subject?.world?.children
            .filter { isValid(platform: $0) }
            .filter { $0.id != lastPlatformId }
            .randomElement()
    }
    
    private func isValid(platform: Entity) -> Bool {
        if platform.isWindowObstacle { return true }
        if includeBottomBound && platform.id == Hotspot.bottomBound.rawValue { return true }
        return false
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
