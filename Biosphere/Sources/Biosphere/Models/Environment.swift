//
// Pet Therapy.
//

import Squanch
import SwiftUI

public struct Environment {
    
    public let bounds: CGRect
    public var children: [Entity] = []
    
    public init(bounds rect: CGRect) {
        bounds = rect
        children.append(contentsOf: hotspots())
    }
    
    public mutating func update(after time: TimeInterval) {
        children
            .filter { !$0.isStatic }
            .forEach { child in
                let collisions = child.collisions(with: children)
                child.update(with: collisions, after: time)
            }
    }
}
