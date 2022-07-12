//
// Pet Therapy.
//

import Squanch
import SwiftUI

public class Environment: ObservableObject {
    
    @Published public var children: [Entity] = []
    
    public private(set) var bounds: CGRect = .zero
    public private(set) var safeAreaInsets: EdgeInsets = .init()
    
    public var events: [Event] = []
        
    // TODO: Use bounds minX and minY rather than safe area
    public init(bounds rect: CGRect, safeAreaInsets: EdgeInsets) {
        set(bounds: rect, safeAreaInsets: safeAreaInsets)
    }
    
    public func set(bounds: CGRect, safeAreaInsets: EdgeInsets) {
        self.bounds = bounds
        self.safeAreaInsets = safeAreaInsets
        let hotspots = Hotspot.allCases.map { $0.rawValue }
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
