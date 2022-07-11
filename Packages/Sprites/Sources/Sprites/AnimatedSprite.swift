//
// Pet Therapy.
//

import AppKit
import Biosphere
import Combine
import Schwifty
import Squanch

open class AnimatedSprite: Capability, ObservableObject {
    
    public let id: String
    
    @Published public private(set) var animation: ImageAnimator = .none
    
    private var lastFrameBeforeAnimations: CGRect
    private var lastState: EntityState = .drag
    private var stateCanc: AnyCancellable!
    
    public required init(with subject: Entity) {
        self.id = "\(subject.id)-Sprite"
        self.lastFrameBeforeAnimations = subject.frame
        super.init(with: subject)
        
        if subject.spritesProvider == nil {
            printDebug(id, "No sprites provider detected")
        }
        
        stateCanc = subject.$state.sink { newState in
            Task { @MainActor in
                self.lastState = newState
                self.updateSprite()
            }
        }
    }
    
    @MainActor
    private func updateSprite() {
        guard let path = subject?.animationPath(for: lastState) else { return }
        guard path != animation.baseName else { return }
        printDebug(id, "Loading", path)
        animation.invalidate()
        animation = buildAnimator(baseName: path, state: lastState)
    }
    
    private func buildAnimator(baseName: String, state: EntityState) -> ImageAnimator {
        guard let subject = subject else { return .none }
        let frames = subject.spritesProvider?.frames(for: baseName) ?? []
        
        if case .animation(let anim, let requiredLoops) = state {
            let requiredFrame = anim.frame(for: subject)
            
            return ImageAnimator(
                baseName: baseName,
                frames: frames,
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
            return ImageAnimator(baseName: baseName, frames: frames)
        }
    }
    
    public func handleAnimationStarted(setFrame requiredFrame: CGRect) {
        printDebug(id, "Animation started")
        subject?.movement?.isEnabled = false
        subject?.set(frame: requiredFrame)
    }
    
    public func handleAnimationCompleted() {
        printDebug(id, "Animation completed")
        subject?.set(frame: lastFrameBeforeAnimations)
        subject?.set(state: .move)
        subject?.movement?.isEnabled = true
    }
    
    open override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled, let subject = subject else { return }
        
        if let next = animation.nextFrame(after: time) {
            subject.sprite = next
        }
        if !subject.state.isAnimation {
            lastFrameBeforeAnimations = subject.frame
        }
    }
    
    open override func uninstall() {
        subject?.sprite = nil
        super.uninstall()
        animation = .none
        stateCanc?.cancel()
        stateCanc = nil
    }
}

// MARK: - Entity Utils

extension Entity {
    
    public var animation: AnimatedSprite? { capability(for: AnimatedSprite.self) }
    
    public var isDrawable: Bool { animation != nil }
}
