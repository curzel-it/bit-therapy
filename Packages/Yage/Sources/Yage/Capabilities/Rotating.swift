import SwiftUI

public class Rotating: Capability {
    public var z: Double = 0
    public var isFlippedVertically: Bool = false
    public var isFlippedHorizontally: Bool = false
    
    public required init(for subject: Entity) {
        super.init(for: subject)
        isEnabled = false
    }
}

public extension Entity {
    var rotation: Rotating? {
        capability(for: Rotating.self)
    }
}
