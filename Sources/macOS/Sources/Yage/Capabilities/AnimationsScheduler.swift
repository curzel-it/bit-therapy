import Foundation
import Schwifty

public class AnimationsScheduler: Capability {
    public override func install(on subject: Entity) {
        super.install(on: subject)
        DispatchQueue.main.async { [weak self] in
            self?.scheduleAnimationAfterRandomInterval()
        }
    }

    public func animateNow() {
        guard let animation = subject?.animationsProvider?.randomAnimation() else { return }
        let loops = animation.requiredLoops ?? Int.random(in: 1 ... 2)
        schedule(animation, times: loops, after: 0)
        Logger.log(tag, "Immediate animation requested", animation.description, "x\(loops)")
    }

    private func scheduleAnimationAfterRandomInterval() {
        guard let animation = subject?.animationsProvider?.randomAnimation() else { return }
        let delay = TimeInterval.random(in: 10...30)
        let loops = animation.requiredLoops ?? 1
        schedule(animation, times: loops, after: delay)
        Logger.log(tag, "Scheduled", animation.description, "x\(loops) in \(delay)\"")
    }

    public func schedule(_ animation: EntityAnimation, times: Int, after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            guard self.isEnabled && self.subject?.isAlive == true else { return }
            self.load(animation, times: times)
            self.scheduleAnimationAfterRandomInterval()
        }
    }

    public func load(_ animation: EntityAnimation, times: Int) {
        guard case .move = subject?.state else { return }
        Logger.log(tag, "Loading", animation.description)
        subject?.set(state: .action(action: animation, loops: times))
    }
}

public extension Entity {
    var animationsScheduler: AnimationsScheduler? {
        capability(for: AnimationsScheduler.self)
    }
}
