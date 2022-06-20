//
// Pet Therapy.
//

import SwiftUI

open class Entity: Identifiable, ObservableObject {
    
    @Published public private(set) var frame: CGRect
    @Published public private(set) var direction: CGVector = .zero
    @Published public var speed: CGFloat = 0
    @Published public var isAlive = true
    @Published public var isUpsideDown = false
    
    public let id: String
    
    public var sprites: [Sprite] = []
    public var capabilities: [Capability] = []
    public var isStatic: Bool = false
    public var isDrawable: Bool = true
    public var isEphemeral: Bool = false
    public var backgroundColor: Color = .clear
    
    public let habitatBounds: CGRect
    
    public init(id: String, frame: CGRect, in habitatBounds: CGRect) {
        self.id = id
        self.frame = frame
        self.habitatBounds = habitatBounds
    }
    
    // MARK: - Direction
    
    open func set(direction newDirection: CGVector) {
        direction = newDirection
    }
    
    open func facingDirection() -> CGVector { direction }
    
    // MARK: - Update
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        if isAlive {
            capabilities.forEach {
                $0.update(with: collisions, after: time)
            }
        }
        sprites.forEach {
            $0.update(with: collisions, after: time)
        }
    }
    
    // MARK: - Behaviors
    
    @discardableResult
    public func install<T: Capability>(_ type: T.Type) -> T {
        let capability = type.init(with: self)
        capabilities.append(capability)
        return capability
    }
    
    @discardableResult
    public func installAll<T: Capability>(_ types: [T.Type]) -> [T] {
        types.map { install($0) }
    }
    
    public func capability<T: Capability>(for someType: T.Type) -> T? {
        capabilities.first { $0 as? T != nil } as? T
    }
    
    public func uninstall<T: Capability>(_ type: T.Type) {
        capabilities = capabilities.filter { capability in
            if let targeted = capability as? T {
                targeted.uninstall()
                return false
            }
            return true
        }
    }
    
    // MARK: - Memory Management

    open func kill(animated: Bool, onCompletion: @escaping () -> Void) {
        kill()
        onCompletion()
    }

    open func kill() {
        uninstallAllCapabilities()
        sprites.forEach { $0.kill() }
        isAlive = false
    }
    
    public func uninstallAllCapabilities() {
        capabilities.forEach { $0.uninstall() }
        capabilities = []
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

extension Entity: Equatable {
    
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }
}
