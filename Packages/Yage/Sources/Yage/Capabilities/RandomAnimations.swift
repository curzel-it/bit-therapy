import Foundation
import Squanch

public class RandomAnimations: Capability {
    private var timer: Timer!
           
    public override func install(on subject: Entity) {
        super.install(on: subject)
        startAnimating()
    }
    
    func startAnimating() {
        guard subject?.animationsProvider != nil else {
            timer?.invalidate()
            timer = Timer(timeInterval: 1, repeats: false) { [weak self] _ in
                self?.startAnimating()
            }
            RunLoop.current.add(timer, forMode: .common)
            return
        }
        scheduleAnimationAfterRandomInterval()
    }
    
    // MARK: - Random Animations
    
    private func scheduleAnimationAfterRandomInterval() {
        timer?.invalidate()
        guard let animation = subject?.animationsProvider?.randomAnimation() else { return }
        let delay = TimeInterval.random(in: 10...30)
        let loops = animation.requiredLoops ?? Int.random(in: 1...2)
        schedule(animation, times: loops, after: delay)
        printDebug(tag, "Scheduled", animation.description, "x\(loops) in \(delay)\"")
    }
    
    private func schedule(_ animation: EntityAnimation, times: Int, after delay: TimeInterval) {
        timer = Timer(timeInterval: delay, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            guard self.isEnabled && self.subject?.isAlive == true else { return }
            self.load(animation, times: times)
            self.scheduleAnimationAfterRandomInterval()
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func load(_ animation: EntityAnimation, times: Int) {
        guard case .move = subject?.state else { return }
        printDebug(tag, "Loading", animation.description)
        subject?.set(state: .action(action: animation, loops: times))
    }
    
    public override func kill() {
        timer?.invalidate()
        timer = nil
        super.kill()
    }
}
