import SwiftUI

public class Rotating: Capability {
    public var angles = Rotation()
    
    public func set(x: Double, y: Double, z: Double) {
        angles.x = x
        angles.y = y
        angles.z = z
    }
    
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

public struct Rotation {
    public var x: Double = 0
    public var y: Double = 0
    public var z: Double = 0
}
