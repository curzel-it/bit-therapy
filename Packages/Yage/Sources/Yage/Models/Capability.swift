import Schwifty
import SwiftUI

open class Capability {
    public weak var subject: Entity?
    public var isEnabled: Bool = true

    public lazy var tag: String = {
        let name = String(describing: type(of: self))
        let id = subject?.id ?? "n/a"
        return "\(name)-\(id)"
    }()
    
    public required init() {}

    open func install(on subject: Entity) {
        Logger.log(subject.id, "Installing", String(describing: self))
        self.subject = subject
    }
    
    func update(with collisions: Collisions, after time: TimeInterval) {
        doUpdate(with: collisions, after: time)
    }
    
    open func doUpdate(with collisions: Collisions, after time: TimeInterval) {
    }

    open func kill(autoremove: Bool = true) {
        if autoremove {
            subject?.capabilities.removeAll { $0.tag == tag }
        }
        subject = nil
        isEnabled = false
    }
}

public extension Entity {
    func install(_ capability: Capability) {
        capability.install(on: self)
        capabilities.append(capability)
    }
}

open class CapabilitiesDiscoveryService {
    public static var shared = CapabilitiesDiscoveryService()
    
    public init() {}
    
    open func capability(for id: String) -> Capability? {
        fatalError("Override CapabilitiesDiscoveryService.shared with your own instance.")
    }
}
