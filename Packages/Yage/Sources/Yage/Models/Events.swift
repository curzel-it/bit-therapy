import Foundation

// MARK: - Schedule

public enum EventSchedule: Equatable {
    case timeOfDay(hour: Int, minute: Int)
    case every(timeInterval: TimeInterval)
    
    public static func from(string: String) -> EventSchedule? {
        return timeOfDay(from: string) ?? everyTimeInterval(from: string)
    }
    
    static func timeOfDay(from string: String) -> EventSchedule? {
        guard string.starts(with: "daily") else { return nil }
        let tokens = string.components(separatedBy: ":")
        guard
            tokens.count == 3,
            let hour = Int(tokens[1]), hour >= 0, hour <= 24,
            let minute = Int(tokens[2]), minute >= 0, minute <= 59
        else { return nil }
        return .timeOfDay(hour: hour, minute: minute)
    }
    
    static func everyTimeInterval(from string: String) -> EventSchedule? {
        guard string.starts(with: "every") else { return nil }
        let tokens = string.components(separatedBy: ":")
        let units: [String: TimeInterval] = ["minutes": 60.0, "hours": 3600.0]
        guard tokens.count == 3,
              let unit = units[tokens[1]],
              let count = TimeInterval(tokens[2]), count > 0
        else { return nil }
        return .every(timeInterval: unit * count)
    }
}

extension EventSchedule: CustomStringConvertible {
    public var description: String {
        switch self {
        case .timeOfDay(let hour, let minute):
            let hours = String(format: "%02d", hour)
            let minutes = String(format: "%02d", minute)
            return "Every day at \(hours):\(minutes)"
            
        case .every(let timeInterval):
            let minutes = String(format: "%0.1f", timeInterval / 60.0)
            return "Every ~\(minutes) minutes"
        }
    }
}

extension EventSchedule {
    public func timer(action: @escaping () -> Void) -> Timer {
        switch self {
        case .timeOfDay:
            return Timer(fire: nextDate(), interval: .oneDay, repeats: true) { _ in action() }
        case .every(let timeInterval):
            return Timer(timeInterval: timeInterval, repeats: true) { _ in action() }
        }
    }
    
    func nextDate() -> Date {
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
            
        case .every(let timeInterval): return Date().addingTimeInterval(timeInterval)
        }
    }
}

// MARK: - Event

public class Event: Identifiable {
    public let id: String = UUID().uuidString
    public let schedulingRule: EventSchedule
    
    private weak var environment: World?
    private var action: (World) -> Void
    private var timer: Timer?
    
    init(
        in environment: World,
        every time: EventSchedule,
        do action: @escaping (World) -> Void
    ) {
        self.schedulingRule = time
        self.action = action
        self.environment = environment
        schedule(every: time)
    }
    
    // MARK: - Scheduling
    
    private func schedule(every time: EventSchedule) {
        timer = time.timer { [weak self] in
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
