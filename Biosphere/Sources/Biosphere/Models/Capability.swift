//
// Pet Therapy.
//

import SwiftUI

open class Capability {
    
    public weak var subject: Entity?
    
    public var isEnabled: Bool = true
    
    public required init(with subject: Entity) {
        self.subject = subject
    }
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        // ...
    }
    
    open func uninstall() {
        self.isEnabled = false
        self.subject = nil
    }
}

public typealias Capabilities = [Capability.Type]
