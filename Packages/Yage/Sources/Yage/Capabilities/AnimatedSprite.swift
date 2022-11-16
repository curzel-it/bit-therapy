import Combine
import NotAGif
import Schwifty
import SwiftUI

public class AnimatedSprite: Capability, ObservableObject {
    public private(set) var animation: ImageAnimator = .none
    
    private var lastFrameBeforeAnimations: CGRect = .zero
    private var lastState: EntityState = .drag
    private var stateCanc: AnyCancellable!
        
    public required init(for subject: Entity) {
        super.init(for: subject)
        self.lastFrameBeforeAnimations = subject.frame
    }
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        updateSpriteIfStateChanged()
        loadNextFrame(after: time)
        storeFrameIfNeeded()
    }
    
    public override func kill(autoremove: Bool = true) {
        setSprite(nil)
        super.kill(autoremove: autoremove)
        animation = .none
        stateCanc?.cancel()
        stateCanc = nil
    }
    
    private func updateSpriteIfStateChanged() {
        guard let newState = subject?.state, newState != lastState else { return }
        lastState = newState
        updateSprite()
    }
    
    private func loadNextFrame(after time: TimeInterval) {
        guard let next = animation.nextFrame(after: time) else { return }
        setSprite(next)
    }
    
    private func storeFrameIfNeeded() {
        guard let subject = subject else { return }
        guard !subject.state.isAction else { return }
        lastFrameBeforeAnimations = subject.frame
    }
    
    private func updateSprite() {
        guard let path = subject?.animationPath(for: lastState) else { return }
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
        subject?.frame = requiredFrame
    }
    
    func handleAnimationCompleted() {
        printDebug(tag, "Animation completed")
        subject?.frame = lastFrameBeforeAnimations
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
