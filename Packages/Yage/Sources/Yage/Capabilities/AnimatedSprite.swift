import Combine
import NotAGif
import Schwifty
import Squanch
import SwiftUI

public class AnimatedSprite: Capability, ObservableObject {
    @Published public private(set) var animation: ImageAnimator = .none
    
    private var lastFrameBeforeAnimations: CGRect = .zero
    private var lastState: EntityState = .drag
    private var stateCanc: AnyCancellable!
        
    public override func install(on subject: Entity) {
        super.install(on: subject)
        self.lastFrameBeforeAnimations = subject.frame
        
        stateCanc = subject.$state.sink { newState in
            Task { @MainActor in
                self.lastState = newState
                self.updateSprite()
            }
        }
    }
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let subject = subject else { return }
        
        if let next = animation.nextFrame(after: time) {
            setSprite(next)
        }
        if !subject.state.isAction {
            lastFrameBeforeAnimations = subject.frame
        }
    }
    
    public override func kill() {
        setSprite(nil)
        super.kill()
        animation = .none
        stateCanc?.cancel()
        stateCanc = nil
    }
    
    @MainActor
    func updateSprite() {
        guard let renderable = subject else { return }
        guard let path = renderable.animationPath(for: lastState) else { return }
        guard path != animation.baseName else { return }
        printDebug(tag, "Loading", path)
        animation.clearHooks()
        animation = buildAnimator(baseName: path, state: lastState)
        if let frame = animation.currentFrame() { setSprite(frame) }
    }
    
    private func buildAnimator(baseName: String, state: EntityState) -> ImageAnimator {
        guard let subject = subject else { return .none }
        guard let frames = subject.spritesProvider?.frames(for: baseName) else {
            printDebug(tag, "No sprites to load")
            return .none
        }
        
        if case .action(let anim, let requiredLoops) = state {
            let requiredFrame = anim.frame(for: subject)
            
            return ImageAnimator(
                baseName: baseName,
                frames: frames,
                fps: subject.fps,
                onFirstFrameLoaded: { completedLoops in
                    guard completedLoops == 0 else { return }
                    self.handleAnimationStarted(setFrame: requiredFrame)
                },
                onLoopCompleted: { completedLoops in
                    guard requiredLoops == completedLoops else { return }
                    self.handleAnimationCompleted()
                }
            )
        } else {
            return ImageAnimator(
                baseName: baseName,
                frames: frames,
                fps: subject.fps
            )
        }
    }
    
    func handleAnimationStarted(setFrame requiredFrame: CGRect) {
        printDebug(tag, "Animation started")
        subject?.movement?.isEnabled = false
        subject?.set(frame: requiredFrame)
    }
    
    func handleAnimationCompleted() {
        printDebug(tag, "Animation completed")
        subject?.set(frame: lastFrameBeforeAnimations)
        subject?.set(state: .move)
        subject?.movement?.isEnabled = true
    }
    
    private func setSprite(_ value: ImageFrame?) {
        subject?.sprite = value
    }
}

// MARK: - Image Animator

public class ImageAnimator: TimedContentProvider<ImageFrame> {
    
    static let none: ImageAnimator = ImageAnimator(baseName: "", frames: [], fps: 0)
    
    public let baseName: String
    
    public init(
        baseName: String,
        frames: [ImageFrame],
        fps: TimeInterval,
        onFirstFrameLoaded: @escaping (Int) -> Void = { _ in},
        onLoopCompleted: @escaping (Int) -> Void = { _ in}
    ) {
        self.baseName = baseName
        super.init(
            frames: frames,
            fps: fps,
            onFirstFrameOfLoopLoaded: onFirstFrameLoaded,
            onLoopCompleted: onLoopCompleted
        )
    }
}
