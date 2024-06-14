import Foundation

public struct Species: Codable, Hashable {
    public let id: String
    public let animations: [EntityAnimation]
    public let capabilities: [String]
    public let dragPath: String
    public let fallPath: String
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
        fallPath: String = "drag",
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
        self.fallPath = fallPath
        scale = 1
        self.speed = speed
        self.tags = tags
        self.zIndex = zIndex
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        animations = try container.decode([EntityAnimation].self, forKey: .animations)
        capabilities = try container.decode([String].self, forKey: .capabilities)
        dragPath = try container.decode(String.self, forKey: .dragPath)
        fps = try container.decode(TimeInterval.self, forKey: .fps)
        movementPath = try container.decode(String.self, forKey: .movementPath)
        scale = (try? container.decode(CGFloat.self, forKey: .scale)) ?? 1
        speed = try container.decode(CGFloat.self, forKey: .speed)
        tags = try container.decode([String].self, forKey: .tags)
        zIndex = try container.decode(Int.self, forKey: .zIndex)

        if let fallPath = try? container.decode(String.self, forKey: .fallPath) {
            self.fallPath = fallPath
        } else {
            fallPath = dragPath
        }
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
