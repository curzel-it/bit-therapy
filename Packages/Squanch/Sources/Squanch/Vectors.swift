//
// Pet Therapy.
//

import SwiftUI

// MARK: - Magnitude

extension CGVector {
    
    public func magnitude() -> Double {
        sqrt(dx.magnitudeSquared + dy.magnitudeSquared)
    }
    
    public func with(magnitude: CGFloat) -> CGVector {
        guard magnitude != 0 else { return .zero }
        let unit = self.unit()
        return CGVector(
            dx: unit.dx * magnitude,
            dy: unit.dy * magnitude
        )
    }
    
    public func unit() -> CGVector {
        let magnitude = self.magnitude()
        guard magnitude != 0 else { return .zero }
        return CGVector(
            dx: dx / magnitude,
            dy: dy / magnitude
        )
    }
}

// MARK: - Between Points

extension CGVector {
    
    public static func unit(from source: CGPoint, to destination: CGPoint) -> CGVector {
        let distanceX = destination.x - source.x
        let distanceY = destination.y - source.y
        let distance = source.distance(from: destination)
        return CGVector(
            dx: distanceX / distance,
            dy: distanceY / distance
        )
    }
}

// MARK: - String Convertible

extension CGVector: CustomStringConvertible {
    
    public var description: String {
        let xVal = String(format: "%0.2f", dx)
        let yVal = String(format: "%0.2f", dy)
        return "(dx: \(xVal), dy: \(yVal))"
    }
}
