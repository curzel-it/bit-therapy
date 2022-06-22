//
// Pet Therapy.
//

import Foundation

// MARK: - Schedule

public enum EventSchedule {
    case timeOfDay(hour: Int, minute: Int)
}

// MARK: - Event

public class Event {
    
    private let id: String = UUID().uuidString
    
    private weak var environment: Environment?
    private var action: (Environment) -> Void
    private var timer: Timer?
    
    init(
        in environment: Environment,
        every time: EventSchedule,
        do action: @escaping (Environment) -> Void
    ) {
        self.action = action
        self.environment = environment
        schedule(every: time)
    }
    
    // MARK: - Scheduling
    
    private func schedule(every time: EventSchedule) {
        switch time {
        case .timeOfDay(let hour, let minute):
            guard let nextDate = Calendar.current.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: Date()
            ) else { return }
            
            timer = Timer(fire: nextDate, interval: .oneDay, repeats: true) { [weak self] _ in
                guard let env = self?.environment else { return }
                self?.action(env)
                self?.cancel()
            }
        }
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    // MARK: - Cancellation
    
    public func cancel() {
        timer?.invalidate()
        timer = nil
        environment?.events.removeAll { $0 == self }
        environment = nil
        action = { _ in }
    }
}

// MARK: - Equatable

extension Event: Equatable {
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}
