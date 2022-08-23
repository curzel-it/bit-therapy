//
// Pet Therapy.
//

import Squanch
import SwiftUI

public struct EntityAnimation: Equatable {
    
    public let id: String
    public let chance: Double
    public let facingDirection: CGVector?
    
    let size: CGSize?
    let position: Position
    
    public init(
        id: String,
        size: CGSize? = nil,
        position: Position = .fromEntityBottomLeft,
        facingDirection: CGVector? = nil,
        chance: Double = 1
    ) {
        self.id = id
        self.size = size
        self.position = position
        self.facingDirection = facingDirection
        self.chance = chance
    }
    
    public func frame(for entity: Entity) -> CGRect {
        let newSize = size(for: entity.spawnFrame.size)
        let newPosition = position(
            originalFrame: entity.frame,
            newSize: newSize,
            in: entity.habitatBounds
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
        in habitatBounds: CGRect
    ) -> CGPoint {
        switch position {
            
        case .centeredInEntity:
            return entityFrame.origin
                .offset(x: (entityFrame.size.width - newSize.width) / 2)
                .offset(y: (entityFrame.size.height - newSize.height) / 2)
            
        case .fromEntityBottomLeft:
            return entityFrame.origin
                .offset(y: entityFrame.size.height - newSize.height)
            
        case .entityTopLeft:
            return entityFrame.origin
            
        case .habitatTopLeft:
            return habitatBounds.topLeft
            
        case .habitatTopRight:
            return habitatBounds.topRight.offset(x: -entityFrame.width)
            
        case .habitatBottomRight:
            return habitatBounds.bottomRight.offset(by: entityFrame.size.oppositeSign())
            
        case .habitatBottomLeft:
            return habitatBounds.bottomLeft.offset(y: -entityFrame.height)
        }
    }
}

extension EntityAnimation: CustomStringConvertible {
    
    public var description: String { id }
}

extension EntityAnimation {
    
    public enum Position {
        case centeredInEntity
        case fromEntityBottomLeft
        case entityTopLeft
        case habitatTopLeft
        case habitatBottomLeft
        case habitatTopRight
        case habitatBottomRight
    }
}
