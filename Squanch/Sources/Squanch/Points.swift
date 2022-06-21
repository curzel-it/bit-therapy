//
// Pet Therapy.
//

import SwiftUI

// MARK: - Distance

extension CGPoint {
    
    public func distance(from other: CGPoint) -> CGFloat {
        sqrt(pow(other.x - x, 2) + pow(other.y - y, 2))
    }
}

// MARK: - Offset

extension CGPoint {
    
    public func offset(by delta: CGPoint) -> CGPoint {
        return offset(x: delta.x, y: delta.y)
    }
    
    public func offset(by delta: CGSize) -> CGPoint {
        return offset(x: delta.width, y: delta.height)
    }
    
    public func offset(x: CGFloat=0, y: CGFloat=0) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

// MARK: - Init from Vector

extension CGPoint {
    
    public init(vector: CGVector, radius: CGFloat = 1, offset: CGPoint = .zero) {
        self.init(
            x: radius * vector.dx + offset.x,
            y: radius * vector.dy + offset.y
        )
    }
}

// MARK: - String Convertible

extension CGPoint: CustomStringConvertible {
    
    public var description: String {
        let xVal = String(format: "%0.2f", x)
        let yVal = String(format: "%0.2f", y)
        return "(x: \(xVal), y: \(yVal))"
    }
}
