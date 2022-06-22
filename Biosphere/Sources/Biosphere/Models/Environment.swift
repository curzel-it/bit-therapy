//
// Pet Therapy.
//

import Squanch
import SwiftUI

public class Environment: ObservableObject {
    
    @Published public var children: [Entity] = []
    
    public let bounds: CGRect
    
    public var events: [Event] = []
        
    public init(bounds rect: CGRect) {
        bounds = rect
        children.append(contentsOf: hotspots())
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
