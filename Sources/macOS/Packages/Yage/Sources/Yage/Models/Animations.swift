import Schwifty
import SwiftUI

public struct EntityAnimation: Codable {
    public let id: String
    public let facingDirection: CGVector?
    public let requiredLoops: Int?

    let size: CGSize?
    let position: Position

    public init(
        id: String,
        size: CGSize? = nil,
        position: Position = .fromEntityBottomLeft,
        facingDirection: CGVector? = nil,
        requiredLoops: Int? = nil
    ) {
        self.id = id
        self.size = size
        self.position = position
        self.facingDirection = facingDirection
        self.requiredLoops = requiredLoops
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.facingDirection = try container.decodeIfPresent(CGVector.self, forKey: .facingDirection)
        self.requiredLoops = try container.decodeIfPresent(Int.self, forKey: .requiredLoops)
        self.size = try container.decodeIfPresent(CGSize.self, forKey: .size)
        let parsedPosition = try? container.decode(EntityAnimation.Position.self, forKey: .position)
        self.position = parsedPosition ?? .fromEntityBottomLeft
    }

    public func frame(for entity: Entity) -> CGRect {
        let newSize = size(for: entity.frame.size)
        let newPosition = position(
            originalFrame: entity.frame,
            newSize: newSize,
            in: entity.worldBounds
        )
        return CGRect(origin: newPosition, size: newSize)
    }

    private func size(for originalSize: CGSize) -> CGSize {
        guard let customSize = size else { return originalSize }
        return CGSize(
            width: customSize.width * originalSize.width,
            height: customSize.height * originalSize.height
        )
    }

    private func position(
        originalFrame entityFrame: CGRect,
        newSize: CGSize,
        in worldBounds: CGRect
    ) -> CGPoint {
        switch position {
        case .fromEntityBottomLeft:
            return entityFrame.origin
                .offset(y: entityFrame.size.height - newSize.height)

        case .entityTopLeft:
            return entityFrame.origin

        case .worldTopLeft:
            return worldBounds.topLeft

        case .worldTopRight:
            return worldBounds.topRight.offset(x: -entityFrame.width)

        case .worldBottomRight:
            return worldBounds.bottomRight.offset(by: entityFrame.size.oppositeSign())

        case .worldBottomLeft:
            return worldBounds.bottomLeft.offset(y: -entityFrame.height)
        }
    }
}

extension EntityAnimation: CustomStringConvertible {
    public var description: String { id }
}

public extension EntityAnimation {
    enum Position: String, Codable {
        case fromEntityBottomLeft
        case entityTopLeft
        case worldTopLeft
        case worldBottomLeft
        case worldTopRight
        case worldBottomRight
    }
}

public extension EntityAnimation {
    func with(loops: Int) -> EntityAnimation {
        EntityAnimation(
            id: id,
            size: size,
            position: position,
            facingDirection: facingDirection,
            requiredLoops: loops
        )
    }
}
