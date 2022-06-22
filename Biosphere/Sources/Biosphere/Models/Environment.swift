//
// Pet Therapy.
//

import Squanch
import SwiftUI

public class Environment: ObservableObject {
    
    @Published public var children: [Entity] = []
    
    public let bounds: CGRect
    
    public init(bounds rect: CGRect) {
        bounds = rect
        children.append(contentsOf: hotspots())
    }
    
    public func update(after time: TimeInterval) {
        children
            .filter { !$0.isStatic }
            .forEach { child in
                let collisions = child.collisions(with: children)
                child.update(with: collisions, after: time)
            }
    }
}
