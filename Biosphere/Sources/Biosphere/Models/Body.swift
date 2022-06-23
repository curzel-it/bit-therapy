//
// Pet Therapy.
//

import SwiftUI
import Squanch

open class Body: Identifiable, ObservableObject {
    
    public let id: String
    public let habitatBounds: CGRect
    
    @Published public private(set) var state: EntityState = .move
    @Published public private(set) var frame: CGRect
    @Published public private(set) var direction: CGVector = .zero
    
    @Published public var speed: CGFloat = 0
    @Published public var isAlive = true
    
    public var isStatic: Bool = false
    public var isEphemeral: Bool = false
    
    fileprivate var storedDirection: CGVector?
    fileprivate var storedFrame: CGRect?
    
    public init(id: String, frame: CGRect, in habitatBounds: CGRect) {
        self.id = id
        self.frame = frame
        self.habitatBounds = habitatBounds
    }
    
    // MARK: - Direction
    
    open func set(direction newDirection: CGVector) {
        direction = newDirection
    }
    
    open func facingDirection() -> CGVector {
        if case .animation(let animation) = state {
            if let direction = animation.facingDirection {
                return direction
            }
        }
        return storedDirection ?? direction
    }
    
    // MARK: - Memory Management
    
    open func kill() {
        isAlive = false
    }
    
    // MARK: - Frame
    
    public func set(frame newFrame: CGRect) {
        guard newFrame != frame else { return }
        frame = newFrame
    }
    
    public func set(origin: CGPoint) {
        guard origin != frame.origin else { return }
        frame.origin = origin
    }
    
    public func set(size: CGSize) {
        guard size != frame.size else { return }
        frame.size = size
    }
    
    // MARK: - State
    
    open func set(state: EntityState) {
        printDebug(id, "State changed to", state.description)
        if case .animation(let animation) = state {
            storeDirectionAndFrame()
            set(frame: animation.frame(from: frame, in: habitatBounds))
            set(direction: .zero)
        } else {
            restoreDirectionAndFrame()
        }
        self.state = state
    }
    
    private func storeDirectionAndFrame() {
        storedDirection = direction
        storedFrame = frame
    }
    
    private func restoreDirectionAndFrame() {
        set(direction: storedDirection ?? direction)
        set(frame: storedFrame ?? frame)
        storedDirection = nil
        storedFrame = nil
    }
}

// MARK: - Equatable

extension Body: Equatable {
    
    public static func == (lhs: Body, rhs: Body) -> Bool {
        lhs.id == rhs.id
    }
}
