//
// Pet Therapy.
//

import SwiftUI

extension CGVector: CustomStringConvertible {
    
    public var description: String {
        let xVal = String(format: "%0.2f", dx)
        let yVal = String(format: "%0.2f", dy)
        return "(dx: \(xVal), dy: \(yVal))"
    }
}

extension CGPoint {
    
    public init(vector: CGVector, radius: CGFloat = 1, offset: CGPoint = .zero) {
        self.init(
            x: radius * vector.dx + offset.x,
            y: radius * vector.dy + offset.y
        )
    }
}
