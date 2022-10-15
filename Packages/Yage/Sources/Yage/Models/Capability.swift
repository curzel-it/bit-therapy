import SwiftUI

open class Capability {
    public weak var subject: Entity?
    public var isEnabled: Bool = true
    
    public init() {}
    
    public lazy var tag: String = {
        let name = String(describing: type(of: self))
        let id = subject?.id ?? "n/a"
        return "\(name)-\(id)"
    }()
    
    open func install(on subject: Entity) {
        self.subject = subject
    }
    
    open func update(with collisions: Collisions, after time: TimeInterval) {}
    
    open func kill() {
        subject = nil
        isEnabled = false
    }
}

public typealias Capabilities = [Capability]

extension Capabilities {
    private static func defaultsStatic() -> Capabilities {
        [RandomAnimations(), AnimatedSprite()]
    }
    
    public static func crawler() -> Capabilities {
        defaultsStatic() + [
            LinearMovement(),
            ReactToHotspots(),
            WallCrawler()
        ]
    }
    
    public static func walker() -> Capabilities {
        defaultsStatic() + [
            LinearMovement(),
            BounceOnLateralCollisions(),
            FlipHorizontallyWhenGoingLeft(),
            ReactToHotspots()
        ]
    }
}
