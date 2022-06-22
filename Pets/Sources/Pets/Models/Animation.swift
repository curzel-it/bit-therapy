//
// Pet Therapy.
//

import Biosphere
import Foundation

public struct PetAnimation: Equatable {
    
    public let id: String
    public let chance: Double
    public let facingDirection: CGVector?
    public let frameTime: TimeInterval?
    
    let size: CGSize?
    let position: Position
    
    init(
        id: String,
        size: CGSize? = nil,
        position: Position = .entityCenter,
        facingDirection: CGVector? = nil,
        frameTime: TimeInterval? = nil,
        chance: Double = 1
    ) {
        self.id = id
        self.size = size
        self.position = position
        self.facingDirection = facingDirection
        self.frameTime = frameTime
        self.chance = chance
    }
    
    public func frame(from petFrame: CGRect, in habitatBounds: CGRect) -> CGRect {
        let newSize = size(for: petFrame.size)
        let newPosition = position(
            originalFrame: petFrame,
            newSize: newSize,
            in: habitatBounds
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
        originalFrame petFrame: CGRect,
        newSize: CGSize,
        in habitatBounds: CGRect
    ) -> CGPoint {
        switch position {
            
        case .entityCenter:
            return petFrame.origin
                .offset(x: (petFrame.size.width - newSize.width) / 2)
                .offset(y: (petFrame.size.height - newSize.height) / 2)
            
        case .entityTopLeft:
            return petFrame.origin
            
        case .habitatTopLeft:
            return habitatBounds.topLeft
            
        case .habitatTopRight:
            return habitatBounds.topRight.offset(x: -petFrame.width)
            
        case .habitatBottomRight:
            return habitatBounds.bottomRight.offset(by: petFrame.size.oppositeSign())
            
        case .habitatBottomLeft:
            return habitatBounds.bottomLeft.offset(y: -petFrame.height)
        }
    }
}

extension PetAnimation: CustomStringConvertible {
    
    public var description: String { id }
}

extension PetAnimation {
    
    enum Position {
        case entityCenter
        case entityTopLeft
        case habitatTopLeft
        case habitatBottomLeft
        case habitatTopRight
        case habitatBottomRight
    }
}
