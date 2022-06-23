//
// Pet Therapy.
//

import AppKit
import Combine
import Schwifty
import Squanch

open class AnimatedSprite: Capability, ObservableObject {
    
    public let id: String
    
    @Published public private(set) var animation: ImageAnimator = .none
    
    private var lastState: EntityState = .drag
    private var lastDirection: CGVector = .zero
    private var stateCanc: AnyCancellable!
    private var directionCanc: AnyCancellable!
    
    public required init(with subject: Entity) {
        self.id = "\(subject.id)-Sprite"
        super.init(with: subject)
        
        stateCanc = subject.$state.sink { newState in
            self.lastState = newState
            self.updateAnimation()
        }
        directionCanc = subject.$direction.sink { newDirection in
            self.lastDirection = newDirection
            self.updateAnimation()
        }
    }
    
    private func updateAnimation() {
        guard let subject = subject else { return }
        guard let path = subject.animationPath(for: lastState) else { return }
        guard path != animation.baseName else { return }
        printDebug(id, "Loaded", path)
        animation = ImageAnimator(path)
    }
    
    open override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        if let next = animation.nextFrame(after: time) {
            subject?.sprite = next
        }
    }
    
    open override func uninstall() {
        subject?.sprite = nil
        super.uninstall()
        animation = .none
        stateCanc?.cancel()
        stateCanc = nil
        directionCanc?.cancel()
        directionCanc = nil
    }
}

extension Entity {
    
    public var animation: AnimatedSprite? { capability(for: AnimatedSprite.self) }
    
    public var isDrawable: Bool { animation != nil }
}
