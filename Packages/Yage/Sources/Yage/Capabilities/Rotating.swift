import SwiftUI

public class Rotating: Capability {
    public var zAngle: CGFloat = 0
    public var isFlippedVertically: Bool = false
    public var isFlippedHorizontally: Bool = false
    
    public override func install(on subject: Entity) {
        super.install(on: subject)
        isEnabled = false
    }
}

public extension Entity {
    var rotation: Rotating? {
        capability(for: Rotating.self)
    }
}
