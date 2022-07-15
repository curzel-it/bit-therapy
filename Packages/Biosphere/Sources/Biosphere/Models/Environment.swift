//
// Pet Therapy.
//

import Squanch
import SwiftUI

public class Environment: ObservableObject {
    
    @Published public var children: [Entity] = []
    
    public private(set) var bounds: CGRect = .zero
    
    public var events: [Event] = []
        
    public init(bounds rect: CGRect) {
        set(bounds: rect)
    }
    
    public func set(bounds: CGRect) {
        self.bounds = bounds
        
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
    
    @discardableResult
    public func schedule(
        every time: EventSchedule,
        do action: @escaping (Environment) -> Void
    ) -> Event {
        let event = Event(in: self, every: time, do: action)
        self.events.append(event)
        return event
    }
}
