import Foundation

public struct Species {
    public fileprivate(set) var id: String
    public fileprivate(set) var behaviors: [EntityBehavior] = []
    public fileprivate(set) var capabilities: () -> Capabilities = { [] }
    public fileprivate(set) var fps: TimeInterval = 10
    public fileprivate(set) var speed: CGFloat = 1
    public fileprivate(set) var movementPath: String = "walk"
    public fileprivate(set) var dragPath: String = "drag"

    public init(id: String) {
        self.id = id
    }

    init(from species: Species) {
        self.init(id: species.id)
        behaviors = species.behaviors
        capabilities = species.capabilities
        fps = species.fps
        movementPath = species.movementPath
        dragPath = species.dragPath
        speed = species.speed
    }
}

// MARK: - Equatable

extension Species: Equatable {
    public static func == (lhs: Species, rhs: Species) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Identifiable

extension Species: Identifiable {}

// MARK: - Known Species

public extension Species {
    static let agent = Species(id: "agent")
    static let hotspot = Species(id: "hotspot")
}

// MARK: - Builder

public extension Species {
    func with(id: String) -> Species {
        var species = Species(from: self)
        species.id = id
        return species
    }

    func with(speed: CGFloat) -> Species {
        var species = Species(from: self)
        species.speed = speed
        return species
    }

    func with(fps: CGFloat) -> Species {
        var species = Species(from: self)
        species.fps = fps
        return species
    }

    func with<T: Capability>(capability: T.Type) -> Species {
        var species = Species(from: self)
        species.capabilities = { capabilities() + [capability] }
        return species
    }

    func with(animation: EntityAnimation) -> Species {
        with(animations: [animation])
    }

    func with(animation: EntityAnimation, when trigger: EntityBehavior.Trigger) -> Species {
        with(additionalBehavior: .init(trigger: trigger, possibleAnimations: [animation]))
    }

    func with(animations: [EntityAnimation]) -> Species {
        let behavior = EntityBehavior(trigger: .random, possibleAnimations: animations)
        return with(additionalBehavior: behavior)
    }

    func with(additionalBehavior: EntityBehavior) -> Species {
        with(additionalBehaviors: [additionalBehavior])
    }

    func with(additionalBehaviors: [EntityBehavior]) -> Species {
        var species = Species(from: self)
        species.behaviors.append(contentsOf: additionalBehaviors)
        return species
    }

    func with(movementPath: String) -> Species {
        var species = Species(from: self)
        species.movementPath = movementPath
        return species
    }

    func with(dragPath: String) -> Species {
        var species = Species(from: self)
        species.dragPath = dragPath
        return species
    }
}
