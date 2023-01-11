import Foundation

public struct Species: Codable, Hashable {
    public let id: String
    public let animations: [EntityAnimation]
    public let capabilities: [String]
    public let fps: TimeInterval
    public let speed: CGFloat
    public let movementPath: String
    public let dragPath: String
    public let zIndex: Int

    public init(
        id: String,
        animations: [EntityAnimation] = [],
        capabilities: [String] = [],
        fps: TimeInterval = 10,
        movementPath: String = "walk",
        dragPath: String = "drag",
        speed: CGFloat = 1,
        zIndex: Int = 0
    ) {
        self.id = id
        self.animations = animations
        self.capabilities = capabilities
        self.fps = fps
        self.movementPath = movementPath
        self.dragPath = dragPath
        self.speed = speed
        self.zIndex = zIndex
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
