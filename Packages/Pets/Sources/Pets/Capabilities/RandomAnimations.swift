import Combine
import DesktopKit
import Squanch
import SwiftUI

public class RandomAnimations: Capability {
    
    private let tag: String
    private var timer: Timer!
           
    public required init(with subject: Entity) {
        tag = "RandomAnimations-\(subject.id)"
        super.init(with: subject)
        scheduleAnimationAfterRadomInterval()
    }
    
    // MARK: - Random Animations
    
    private func scheduleAnimationAfterRadomInterval() {
        timer?.invalidate()
        guard let pet = subject as? PetEntity else { return }
        guard let animation = pet.species.randomAnimation() else { return }
        let delay = TimeInterval.random(in: 10...30)
        let loops = Int.random(in: 1...2)
        printDebug(tag, "Scheduling", animation.description, "x\(loops)", "in", String(format: "%0.2f", delay))
        schedule(animation, times: loops, after: delay)
    }
    
    private func schedule(_ animation: EntityAnimation, times: Int, after delay: TimeInterval) {
        timer = Timer(timeInterval: delay, repeats: false) { [weak self] _ in
            self?.load(animation, times: times)
            self?.scheduleAnimationAfterRadomInterval()
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func load(_ animation: EntityAnimation, times: Int) {
        guard let pet = subject as? PetEntity else { return }
        guard case .move = pet.state else { return }
        printDebug(tag, "Loading", animation.description)
        pet.set(state: .animation(animation: animation, loops: times))
    }
    
    // MARK: - Uninstall
    
    public override func uninstall() {
        super.uninstall()
    }
}
