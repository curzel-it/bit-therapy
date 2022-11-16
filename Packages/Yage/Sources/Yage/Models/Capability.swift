import Schwifty
import SwiftUI

open class Capability {
    public weak var subject: Entity?
    public var isEnabled: Bool = true
    
    public required init(for subject: Entity) {
        self.subject = subject
    }
    
    public lazy var tag: String = {
        let name = String(describing: type(of: self))
        let id = subject?.id ?? "n/a"
        return "\(name)-\(id)"
    }()
    
    @discardableResult
    open class func install(on subject: Entity) -> Self {
        printDebug(subject.id, "Installing", String(describing: self))
        let capability = Self.init(for: subject)
        subject.capabilities.append(capability)
        return capability
    }
    
    open func update(with collisions: Collisions, after time: TimeInterval) {}
    
    open func kill(autoremove: Bool = true) {
        if autoremove {
            subject?.capabilities.removeAll { $0.tag == tag }
        }
        subject = nil
        isEnabled = false
    }
}

public typealias Capabilities = [Capability.Type]

extension Capabilities {
    private static func defaultsStatic() -> Capabilities {
        [RandomAnimations.self, AnimatedSprite.self]
    }
    
    public static func crawler() -> Capabilities {
        defaultsStatic() + [
            LinearMovement.self,
            ReactToHotspots.self,
            WallCrawler.self
        ]
    }
    
    public static func walker() -> Capabilities {
        defaultsStatic() + [
            LinearMovement.self,
            BounceOnLateralCollisions.self,
            FlipHorizontallyWhenGoingLeft.self,
            ReactToHotspots.self
        ]
    }
}
