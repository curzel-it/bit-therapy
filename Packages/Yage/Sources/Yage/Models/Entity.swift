import Schwifty
import SwiftUI

open class Entity: Identifiable {
    public let species: Species
    public let id: String
    public var capabilities: [Capability] = []
    public var direction: CGVector = .zero
    public var fps: TimeInterval = 10
    public var frame: CGRect
    public var isAlive = true
    public var isEphemeral: Bool = false
    public var isStatic: Bool = false
    public var speed: CGFloat = 0
    public var sprite: String?
    public private(set) var state: EntityState = .move
    public var worldBounds: CGRect
    public var zIndex: Int

    public init(
        species: Species,
        id: String,
        frame: CGRect,
        in worldBounds: CGRect
    ) {
        self.species = species
        self.id = id
        self.fps = species.fps
        self.zIndex = species.zIndex
        self.frame = frame
        self.worldBounds = worldBounds
        self.installCapabilities()
    }
    
    private func installCapabilities() {
        species.capabilities.forEach {
            if let capability = CapabilitiesDiscoveryService.shared.capability(for: $0) {
                install(capability)
            }
        }
    }

    // MARK: - Capabilities

    public func capability<T: Capability>(for someType: T.Type) -> T? {
        capabilities.first { $0 as? T != nil } as? T
    }

    // MARK: - Update

    open func update(with collisions: Collisions, after time: TimeInterval) {
        guard isAlive else { return }
        capabilities.forEach {
            $0.update(with: collisions, after: time)
        }
    }

    // MARK: - State

    open func set(state newState: EntityState) {
        state = newState
        Logger.log(id, "State changed to", state.description)
    }

    // MARK: - Memory Management

    open func kill() {
        uninstallAllCapabilities()
        isAlive = false
        sprite = nil
    }

    public func uninstallAllCapabilities() {
        capabilities.forEach { $0.kill(autoremove: false) }
        capabilities = []
    }
}

// MARK: - Debug

extension Entity: CustomStringConvertible {
    public var description: String {
        id
    }
}

// MARK: - Equatable

extension Entity: Equatable {
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }
}
