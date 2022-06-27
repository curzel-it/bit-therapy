//
// Pet Therapy.
//

import Foundation

// MARK: - Schedule

public enum EventSchedule: Equatable {
    case timeOfDay(hour: Int, minute: Int)
}

extension EventSchedule: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .timeOfDay(let hour, let minute):
            let hours = String(format: "%02d", hour)
            let minutes = String(format: "%02d", minute)
            return "Every day at \(hours):\(minutes)"
        }
    }
}

extension EventSchedule {
    
    public func nextDate() -> Date {
        switch self {
        case .timeOfDay(let hour, let minute):
            guard let nextDate = Calendar.current.date(
                bySettingHour: hour, minute: minute, second: 0, of: Date()
            ) else {
                return Date().addingTimeInterval(.oneHour)
            }
            if nextDate < Date() {
                return nextDate.addingTimeInterval(.oneDay)
            }
            return nextDate
        }
    }
}

// MARK: - Event

public class Event: Identifiable {
    
    public let id: String = UUID().uuidString
    public let schedulingRule: EventSchedule
    
    private weak var environment: Environment?
    private var action: (Environment) -> Void
    private var timer: Timer?
    
    init(
        in environment: Environment,
        every time: EventSchedule,
        do action: @escaping (Environment) -> Void
    ) {
        self.schedulingRule = time
        self.action = action
        self.environment = environment
        schedule(every: time)
    }
    
    // MARK: - Scheduling
    
    private func schedule(every time: EventSchedule) {
        timer = Timer(
            fire: time.nextDate(),
            interval: .oneDay,
            repeats: true
        ) { [weak self] _ in
            guard let env = self?.environment else { return }
            self?.action(env)
            self?.cancel()
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
