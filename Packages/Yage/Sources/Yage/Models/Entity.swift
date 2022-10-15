import Squanch
import SwiftUI

open class Entity: Identifiable, ObservableObject {
    public let id: String
    public let worldBounds: CGRect
    public var fps: TimeInterval = 10
    public var isStatic: Bool = false
    public var isEphemeral: Bool = false
    
    @Published public var isUpsideDown = false
    @Published public var xAngle: CGFloat = 0
    @Published public var yAngle: CGFloat = 0
    @Published public var zAngle: CGFloat = 0
    
    @Published public private(set) var state: EntityState = .move
    @Published public private(set) var frame: CGRect
    @Published public private(set) var direction: CGVector = .zero
    
    @Published public var speed: CGFloat = 0
    @Published public var isAlive = true
    
    @Published public var sprite: ImageFrame?
    @Published public var backgroundColor: Color = .clear
    
    public private(set) var capabilities: [Capability] = []
    
    public init(id: String, frame: CGRect, in worldBounds: CGRect) {
        self.id = id
        self.frame = frame
        self.worldBounds = worldBounds
    }
    
    // MARK: - Capabilities

    public func install(_ capability: Capability) {
        printDebug(id, "Installing", String(describing: type(of: capability)))
        capability.install(on: self)
        capabilities.append(capability)
    }
    
    public func capability<T: Capability>(for someType: T.Type) -> T? {
        capabilities.first { $0 as? T != nil } as? T
    }
    
    public func uninstall<T: Capability>(_ type: T.Type) {
        capabilities = capabilities.filter { capability in
            if let targeted = capability as? T {
                targeted.kill()
                return false
            }
            return true
        }
    }
    
    // MARK: - Update
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isAlive else { return }
        capabilities.forEach {
            $0.update(with: collisions, after: time)
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
        self.state = state
        printDebug(id, "State changed to", state.description)
    }
    
    // MARK: - Memory Management
    
    open func kill() {
        uninstallAllCapabilities()
        isAlive = false
        sprite = nil
    }
    
    public func uninstallAllCapabilities() {
        capabilities.forEach { $0.kill() }
        capabilities = []
    }
    
    // MARK: - Actions
    
    open func actionPath(for state: EntityState) -> String? {
        nil
    }
    
    open func animationPath(for state: EntityState) -> String? { nil }
}

// MARK: - Equatable

extension Entity: Equatable {
    
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }
}
