import SwiftUI
import Yage

extension LiveWorld {
    public func schedule(every time: EventSchedule, action: @escaping () -> Void) {
        let event = Event(every: time, do: action)
        let scheduled = schedule(event: event)
        self.events.append(scheduled)
    }
    
    public func cancel(event: Event) {
        events
            .filter { $0.event == event }
            .forEach { $0.timer.invalidate() }
        events.removeAll { $0.event == event }
    }
    
    private func schedule(event: Event) -> ScheduledEvent {
        let scheduled = ScheduledEvent(event: event, timer: event.timer())
        RunLoop.main.add(scheduled.timer, forMode: .common)
        return scheduled
    }
}

private extension Event {
    func timer() -> Timer {
        switch schedulingRule {
        case .timeOfDay:
            return Timer(
                fire: schedulingRule.nextDate(),
                interval: .oneDay,
                repeats: true
            ) { [weak self] _ in self?.action() }
        case .every(let timeInterval):
            return Timer(
                timeInterval: timeInterval,
                repeats: true
            ) { [weak self] _ in self?.action() }
        }
    }
}

struct ScheduledEvent {
    let event: Event
    let timer: Timer
}
