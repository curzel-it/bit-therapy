import Foundation

// MARK: - Event

public class Event: Identifiable {
    public let id: String = UUID().uuidString
    public let schedulingRule: EventSchedule
    public var action: () -> Void

    public init(
        every time: EventSchedule,
        do action: @escaping () -> Void
    ) {
        schedulingRule = time
        self.action = action
    }
}

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
            let minute = Int(tokens[2]), minute >= 0, minute <= 59 else { return nil }
        return .timeOfDay(hour: hour, minute: minute)
    }

    static func everyTimeInterval(from string: String) -> EventSchedule? {
        guard string.starts(with: "every") else { return nil }
        let tokens = string.components(separatedBy: ":")
        let units: [String: TimeInterval] = ["minutes": 60.0, "hours": 3600.0]
        guard tokens.count == 3,
              let unit = units[tokens[1]],
              let count = TimeInterval(tokens[2]), count > 0 else { return nil }
        return .every(timeInterval: unit * count)
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

        case .every(let timeInterval): return Date().addingTimeInterval(timeInterval)
        }
    }
}

// MARK: - Debug

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

// MARK: - Equatable

extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}
