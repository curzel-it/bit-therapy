import SwiftUI

open class HabitatState: ObservableObject {
    
    @Published public var children: [Entity] = []
    
    public private(set) var bounds: CGRect = .zero
    
    public var events: [Event] = []
        
    public init(bounds rect: CGRect) {
        set(bounds: rect)
    }
    
    open func set(bounds: CGRect) {
        self.bounds = bounds
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
        do action: @escaping (HabitatState) -> Void
    ) -> Event {
        let event = Event(in: self, every: time, do: action)
        self.events.append(event)
        return event
    }
}
