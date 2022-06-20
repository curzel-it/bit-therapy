//
// Pet Therapy.
//

import AppKit

open class Sprite: Identifiable {
    
    public let id: String = UUID().uuidString
    
    public var currentFrame: NSImage?
    
    public var isDrawable: Bool = true
    
    public init() {
        self.currentFrame = nil
    }
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        // ...
    }
    
    open func kill() {
        currentFrame = nil
        isDrawable = false
    }
}
