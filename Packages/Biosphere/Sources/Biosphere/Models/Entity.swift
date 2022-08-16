//
// Pet Therapy.
//

import SwiftUI
import Squanch

open class Entity: Identifiable, ObservableObject {
    
    public let id: String
    public let habitatBounds: CGRect
    public let spawnFrame: CGRect
    
    public var isDrawable: Bool = true
    public var isStatic: Bool = false
    public var isEphemeral: Bool = false
    
    @Published public var isUpsideDown = false
    @Published public var sprite: CGImage?
    @Published public var xAngle: CGFloat = 0
    @Published public var yAngle: CGFloat = 0
    @Published public var zAngle: CGFloat = 0
    
    @Published public private(set) var state: EntityState = .move
    @Published public private(set) var frame: CGRect
    @Published public private(set) var direction: CGVector = .zero
    
    @Published public var backgroundColor: Color = .clear
    
    @Published public var speed: CGFloat = 0
    @Published public var isAlive = true
    
    public var capabilities: [Capability] = []
    
    public init(id: String, frame: CGRect, in habitatBounds: CGRect) {
        self.id = id
        self.frame = frame
        self.spawnFrame = frame
        self.habitatBounds = habitatBounds
    }
    
    // MARK: - Capabilities
    
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
    
    // MARK: - Update
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        if isAlive {
            capabilities.forEach {
                $0.update(with: collisions, after: time)
            }
        }
    }
    
    // MARK: - Direction
    
    open func set(direction newDirection: CGVector) {
        direction = newDirection
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
    
    // MARK: - Memory Management

    open func kill(animated: Bool, onCompletion: @escaping () -> Void = {}) {
        kill()
        onCompletion()
    }
    
    private func kill() {
        uninstallAllCapabilities()
        sprite = nil
        isAlive = false
    }
    
    public func uninstallAllCapabilities() {
        capabilities.forEach { $0.uninstall() }
        capabilities = []
    }
    
    // MARK: - Animations
    
    open func animationPath(for state: EntityState) -> String? {
        nil
    }
}

// MARK: - Equatable

extension Entity: Equatable {
    
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }
}
