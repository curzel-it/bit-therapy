//
// Pet Therapy.
//

import SwiftUI
import Squanch

open class Entity: Body {
    
    @Published public var isUpsideDown = false
    @Published public var sprite: NSImage?
    @Published public var xAngle: CGFloat = 0
    @Published public var yAngle: CGFloat = 0
    @Published public var zAngle: CGFloat = 0
    
    public var capabilities: [Capability] = []
    
    // MARK: - Capabilities
    
    @discardableResult
    public func install<T: Capability>(_ type: T.Type) -> T {
        let capability = type.init(with: self)
        capabilities.append(capability)
        return capability
    }
    
    @discardableResult
    public func installAll<T: Capability>(_ types: [T.Type]) -> [T] {
        types.map { install($0) }
    }
    
    public func capability<T: Capability>(for someType: T.Type) -> T? {
        capabilities.first { $0 as? T != nil } as? T
    }
    
    public func uninstall<T: Capability>(_ type: T.Type) {
        capabilities = capabilities.filter { capability in
            if let targeted = capability as? T {
                targeted.uninstall()
                return false
            }
            return true
        }
    }
    
    // MARK: - Update
    
    open func update(with collisions: Collisions, after time: TimeInterval) {
        if isAlive {
            capabilities.forEach {
                $0.update(with: collisions, after: time)
            }
        }
    }
    
    // MARK: - Memory Management

    open func kill(animated: Bool, onCompletion: @escaping () -> Void) {
        kill()
        onCompletion()
    }
    
    open override func kill() {
        uninstallAllCapabilities()
        sprite = nil
        super.kill()
    }
    
    public func uninstallAllCapabilities() {
        capabilities.forEach { $0.uninstall() }
        capabilities = []
    }
    
    // MARK: - Animations
    
    open override func set(state: EntityState) {
        if state != self.state {
            sprite = nil
        }
        super.set(state: state)
    }
    
    open func animationPath(for state: EntityState) -> String? {
        nil
    }
}
