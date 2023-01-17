import Combine
import NotAGif
import Schwifty
import SwiftUI

public class AnimatedSprite: Capability {
    public private(set) var animation: SpritesAnimator = .none
    private var lastFrameBeforeAnimations: CGRect = .zero
    private var lastState: EntityState = .drag

    public override func install(on subject: Entity) {
        super.install(on: subject)
        lastFrameBeforeAnimations = subject.frame
    }

    override public func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        updateSpriteIfStateChanged()
        loadNextFrame(after: time)
        storeFrameIfNeeded()
    }

    override public func kill(autoremove: Bool = true) {
        setSprite(nil)
        super.kill(autoremove: autoremove)
        animation = .none
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
        guard let subject else { return }
        guard !subject.state.isAction else { return }
        lastFrameBeforeAnimations = subject.frame
    }

    private func updateSprite() {
        guard let path = subject?.spritesProvider?.sprite(state: lastState) else { return }
        guard path != animation.baseName else { return }
        Logger.log(tag, "Loading", path)
        animation.clearHooks()
        animation = buildAnimator(animation: path, state: lastState)
        if let frame = animation.currentFrame() { setSprite(frame) }
    }

    private func buildAnimator(animation: String, state: EntityState) -> SpritesAnimator {
        guard let subject else { return .none }
        guard let frames = subject.spritesProvider?.frames(state: state) else {
            Logger.log(tag, "No sprites to load")
            return .none
        }
        if case .action(let anim, let requiredLoops) = state {
            let requiredFrame = anim.frame(for: subject)
            return SpritesAnimator(
                baseName: animation, frames: frames, fps: subject.fps,
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
            return SpritesAnimator(baseName: animation, frames: frames, fps: subject.fps)
        }
    }

    func handleAnimationStarted(setFrame requiredFrame: CGRect) {
        Logger.log(tag, "Animation started")
        subject?.movement?.isEnabled = false
        subject?.frame = requiredFrame
    }

    func handleAnimationCompleted() {
        Logger.log(tag, "Animation completed")
        subject?.frame = lastFrameBeforeAnimations
        subject?.set(state: .move)
        subject?.movement?.isEnabled = true
    }

    private func setSprite(_ value: String?) {
        subject?.sprite = value
    }
}

// MARK: - Animator

public class SpritesAnimator: TimedContentProvider<String> {
    static let none: SpritesAnimator = .init(baseName: "", frames: [], fps: 0)

    public let baseName: String

    public init(
        baseName: String,
        frames: [String],
        fps: TimeInterval,
        onFirstFrameLoaded: @escaping (Int) -> Void = { _ in },
        onLoopCompleted: @escaping (Int) -> Void = { _ in }
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
