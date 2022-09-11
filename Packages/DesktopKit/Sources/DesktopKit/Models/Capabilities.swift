import Foundation
import Yage

open class DKCapability: Yage.Capability {
    public weak var subject: Entity?
    public weak var renderable: RenderableEntity?
    public var isEnabled: Bool = true
    
    public init() {}
    
    public lazy var tag: String = {
        let name = String(describing: type(of: self))
        let id = subject?.id ?? "n/a"
        return "\(name)-\(id)"
    }()
    
    public func install(on subject: Entity) {
        self.subject = subject
        self.renderable = subject as? RenderableEntity
    }
    
    open func update(with collisions: Collisions, after time: TimeInterval) {}
    
    open func kill() {
        subject = nil
        renderable = nil
        isEnabled = false
    }
}

public typealias DKCapabilities = [Capability]

extension DKCapabilities {
    
    private static func defaultsStatic() -> DKCapabilities {
        [RandomAnimations(), AnimatedSprite()]
    }
    
    public static func crawler() -> DKCapabilities {
        defaultsStatic() + [
            LinearMovement(),
            ReactToHotspots(),
            WallCrawler()
        ]
    }
    
    public static func walker() -> DKCapabilities {
        defaultsStatic() + [
            LinearMovement(),
            BounceOnLateralCollisions(),
            FlipHorizontallyWhenGoingLeft(),
            ReactToHotspots()
        ]
    }
}
