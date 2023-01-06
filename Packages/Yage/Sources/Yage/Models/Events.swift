import Foundation

// MARK: - Event

public class Event: Identifiable {
    public let id: String = UUID().uuidString
    public let schedulingRule: EventSchedule
    public var action: () -> Void

    public init(every time: EventSchedule, do action: @escaping () -> Void) {
        schedulingRule = time
        self.action = action
    }
}

// MARK: - Schedule

public struct EventSchedule: Equatable {
    public let hour: Int
    public let minute: Int
    
    public var description: String {
        let hours = String(format: "%02d", hour)
        let minutes = String(format: "%02d", minute)
        return "Every day at \(hours):\(minutes)"
    }
    
    public init?(from string: String) {
        guard string.starts(with: "daily") else { return nil }
        let tokens = string.components(separatedBy: ":")
        guard tokens.count == 3,
              let hour = Int(tokens[1]), hour >= 0, hour <= 24,
              let minute = Int(tokens[2]), minute >= 0, minute <= 59 else { return nil }
        self.init(hour: hour, minute: minute)
    }
    
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    public func nextDate() -> Date {
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

// MARK: - Equatable

extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}
