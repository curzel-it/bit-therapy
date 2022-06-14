//
// Pet Therapy.
//

import SwiftUI

public struct World {
    
    public var bounds: CGRect
    public var children: [PhysicsEntity] = []
    
    public init(bounds rect: CGRect) {
        bounds = rect
        children = []
        children.append(contentsOf: hotspots())
    }
    
    public mutating func update(after time: TimeInterval) {
        children.forEach { child in
            guard !child.isStatic else { return }
            let collisions = child.collisions(with: children)
            child.update(with: collisions, after: time)
        }
    }
}
