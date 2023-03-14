import Combine
import Schwifty
import SwiftUI
import Yage

class MouseChaser: Capability {
    @Inject private var appConfig: AppConfig
    @Inject private var mouse: MouseTrackingUseCase
    
    private let seeker = Seeker()
    private let mousePosition = MousePosition()
    private var disposables = Set<AnyCancellable>()
        
    override func install(on subject: Entity) {
        super.install(on: subject)
        subject.capabilities.filter { $0 is Seeker }.forEach { $0.kill() }
        subject.capability(for: AnimationsScheduler.self)?.isEnabled = false
        subject.capability(for: RandomPlatformJumper.self)?.isEnabled = false
        subject.setGravity(enabled: false)
        startSeeker()
        mouse.position()
            .sink { [weak self] in self?.positionChanged(to: $0) }
            .store(in: &disposables)
        mouse.start()
    }
    
    private func startSeeker() {
        subject?.install(seeker)
        seeker.follow(
            mousePosition,
            to: .center,
            autoAdjustSpeed: false,
            minDistance: 20,
            maxDistance: 60
        ) { [weak self] in self?.handleCapture(state: $0) }
    }
    
    private func handleCapture(state: Seeker.State) {
        switch state {
        case .captured: playIdleAnimation()
        case .escaped: startMoving()
        case .following: break
        }
    }
    
    private func startMoving() {
        guard let subject else { return }
        subject.set(state: .move)
        subject.direction = CGVector(dx: 1, dy: 0)
        subject.movement?.isEnabled = true
    }
    
    private func playIdleAnimation() {
        let animation = subject?.species.animations.first { $0.id == "front" }
        guard let animation else { return }
        subject?.animationsScheduler?.load(animation, times: 100)
    }
    
    private func positionChanged(to point: CGPoint) {
        mousePosition.frame = CGRect(origin: point, size: .zero)
    }
    
    override func kill(autoremove: Bool = true) {
        mouse.stop()
        seeker.kill()
        subject?.capability(for: AnimationsScheduler.self)?.isEnabled = true
        subject?.capability(for: RandomPlatformJumper.self)?.isEnabled = true
        subject?.setGravity(enabled: appConfig.gravityEnabled)
        subject?.set(state: .move)
        subject?.direction = CGVector(dx: 1, dy: 0)
        subject?.movement?.isEnabled = true
        disposables.removeAll()
        super.kill(autoremove: autoremove)
    }
}

private class MousePosition: SeekerTarget {
    var frame: CGRect = .zero
}
