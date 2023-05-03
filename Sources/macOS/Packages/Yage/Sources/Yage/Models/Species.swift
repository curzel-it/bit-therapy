import Foundation

public struct Species: Codable, Hashable {
    public let id: String
    public let animations: [EntityAnimation]
    public let capabilities: [String]
    public let dragPath: String
    public let fps: TimeInterval
    public let movementPath: String
    public let scale: CGFloat
    public let speed: CGFloat
    public let tags: [String]
    public let zIndex: Int

    public init(
        id: String,
        animations: [EntityAnimation] = [],
        capabilities: [String] = [],
        dragPath: String = "drag",
        fps: TimeInterval = 10,
        movementPath: String = "walk",
        speed: CGFloat = 1,
        tags: [String] = [],
        zIndex: Int = 0
    ) {
        self.id = id
        self.animations = animations
        self.capabilities = capabilities
        self.fps = fps
        self.movementPath = movementPath
        self.dragPath = dragPath
        self.scale = 1
        self.speed = speed
        self.tags = tags
        self.zIndex = zIndex
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.animations = try container.decode([EntityAnimation].self, forKey: .animations)
        self.capabilities = try container.decode([String].self, forKey: .capabilities)
        self.dragPath = try container.decode(String.self, forKey: .dragPath)
        self.fps = try container.decode(TimeInterval.self, forKey: .fps)
        self.movementPath = try container.decode(String.self, forKey: .movementPath)
        self.scale = (try? container.decode(CGFloat.self, forKey: .scale)) ?? 1
        self.speed = try container.decode(CGFloat.self, forKey: .speed)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.zIndex = try container.decode(Int.self, forKey: .zIndex)
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
