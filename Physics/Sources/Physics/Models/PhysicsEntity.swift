//
// Pet Therapy.
//

import SwiftUI

open class PhysicsEntity: Identifiable, ObservableObject {
    
    @Published public private(set) var frame: CGRect
    @Published public private(set) var direction: CGVector = .zero
    @Published public var speed: CGFloat = 0
    @Published public var angle: CGFloat = 0
    
    public let id: String
    
    public var sprites: [Sprite] = []
    public var behaviors: [EntityBehavior] = []
    public var isStatic: Bool = false
    public var isDrawable: Bool = true
    public var isEphemeral: Bool = false
    public var backgroundColor: Color = .clear
    
    private var isAlive = true
    
    public init(
        id: String,
        frame: CGRect,
        behaviors: [EntityBehavior.Type] = []
    ) {
        self.id = id
        self.frame = frame
        self.behaviors = behaviors.map { $0.init(with: self) }
    }
    
    // MARK: - Direction
    
    open func set(direction newDirection: CGVector) {
        direction = newDirection
    }
    
    open func facingDirection() -> CGVector { direction }
    
    // MARK: - Update
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isAlive else { return }
        
        behaviors.forEach {
            $0.update(with: collisions, after: time)
        }
        sprites.forEach {
            $0.update(with: collisions, after: time)
        }
    }
    
    // MARK: - Behaviors
    
    public func behavior<T: EntityBehavior>(for bType: T.Type) -> T? {
        behaviors.first { $0 as? T != nil } as? T
    }
    
    public func uninstall<T: EntityBehavior>(_ type: T.Type) {
        behaviors = behaviors.filter { behavior in
            if let targeted = behavior as? T {
                targeted.uninstall()
                return false
            }
            return true
        }
    }
    
    // MARK: - Memory Management
    
    open func kill() {
        uninstallAllBehaviors()
        sprites.forEach { $0.kill() }
        isAlive = false
    }
    
    public func uninstallAllBehaviors() {
        behaviors.forEach { $0.uninstall() }
        behaviors = []
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
}

// MARK: - Equatable

extension PhysicsEntity: Equatable {
    
    public static func == (lhs: PhysicsEntity, rhs: PhysicsEntity) -> Bool {
        lhs.id == rhs.id
    }
}
