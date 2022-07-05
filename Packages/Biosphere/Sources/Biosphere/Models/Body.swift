//
// Pet Therapy.
//

import SwiftUI
import Squanch

open class Body: Identifiable, ObservableObject {
    
    public let id: String
    public let habitatBounds: CGRect
    public let spawnFrame: CGRect
    
    @Published public private(set) var state: EntityState = .move
    @Published public private(set) var frame: CGRect
    @Published public private(set) var direction: CGVector = .zero
    
    @Published public var speed: CGFloat = 0
    @Published public var isAlive = true
    
    public var isStatic: Bool = false
    public var isEphemeral: Bool = false
        
    public init(id: String, frame: CGRect, in habitatBounds: CGRect) {
        self.id = id
        self.frame = frame
        self.spawnFrame = frame
        self.habitatBounds = habitatBounds
    }
    
    // MARK: - Direction
    
    open func set(direction newDirection: CGVector) {
        direction = newDirection
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
        self.state = state
    }
}

// MARK: - Equatable

extension Body: Equatable {
    
    public static func == (lhs: Body, rhs: Body) -> Bool {
        lhs.id == rhs.id
    }
}
