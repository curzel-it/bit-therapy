import Schwifty
import SwiftUI

open class World {
    public let name: String
    public var children: [Entity] = []
    public private(set) var bounds: CGRect = .zero
    
    public init(name: String, bounds rect: CGRect) {
        self.name = name
        set(bounds: rect)
    }
    
    open func set(bounds newBounds: CGRect) {
        bounds = newBounds
        let hotspots = Hotspot.allCases.map { $0.rawValue }
        let oldBounds = children.filter { hotspots.contains($0.id) }
        oldBounds.forEach { $0.kill() }
        children.removeAll { hotspots.contains($0.id) }
        children.append(contentsOf: hotspotEntities())
    }
    
    public func update(after time: TimeInterval) {
        children
            .filter { !$0.isStatic }
            .forEach { child in
                let collisions = child.collisions(with: children)
                child.update(with: collisions, after: time)
            }
    }
    
    open func kill() {
        children.forEach { $0.kill() }
        children.removeAll()
    }
}
