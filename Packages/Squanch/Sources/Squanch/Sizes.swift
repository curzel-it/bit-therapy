//
// Pet Therapy.
//

import SwiftUI

extension CGSize: CustomStringConvertible {
    
    public var description: String {
        return "(w: \(Int(width)), h: \(Int(height)))"
    }
}

extension CGSize {
    
    public init(square value: CGFloat) {
        self.init(width: value, height: value)
    }
}

extension CGSize {
    
    public func oppositeSign() -> CGSize {
        CGSize(width: -width, height: -height)
    }
}
