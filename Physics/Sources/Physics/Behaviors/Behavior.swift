//
// Pet Therapy.
//

import SwiftUI

open class EntityBehavior {
    
    public weak var body: PhysicsEntity?
    
    public var isEnabled: Bool = true
    
    public required init(with body: PhysicsEntity) {
        self.body = body
    }
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        // ...
    }
    
    open func uninstall() {
        self.isEnabled = false
        self.body = nil
    }
}
