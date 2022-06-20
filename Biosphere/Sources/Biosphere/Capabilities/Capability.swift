//
// Pet Therapy.
//

import SwiftUI

open class Capability {
    
    public weak var body: Entity?
    
    public var isEnabled: Bool = true
    
    public required init(with body: Entity) {
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
