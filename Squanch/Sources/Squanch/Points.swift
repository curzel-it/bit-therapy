//
// Pet Therapy.
//

import SwiftUI

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

extension CGPoint: CustomStringConvertible {
    
    public var description: String {
        let xVal = String(format: "%0.2f", x)
        let yVal = String(format: "%0.2f", y)
        return "(x: \(xVal), y: \(yVal))"
    }
}
