import Foundation
import Squanch
import Yage

class Clock: Capability {
    private var lastTime: TimeOfDay = TimeOfDay(hour: 0, minute: 0)
    
    override func update(with collisions: Collisions, after time: TimeInterval) {
        let newTime = currentTime()
        guard hasTimePassed(given: newTime) else { return }
        lastTime = newTime
        update(given: newTime)
    }
    
    func hasTimePassed(given newTime: TimeOfDay) -> Bool {
        return newTime.hour != lastTime.hour || newTime.minute != lastTime.minute
    }
    
    func currentTime() -> TimeOfDay {
        let date = Date()
        let hour = Calendar.current.component(.hour, from: date)
        let min = Calendar.current.component(.minute, from: date)
        return TimeOfDay(hour: hour, minute: min)
    }
    
    func update(given timeOfDay: TimeOfDay) {
        // ...
    }
}

typealias TimeOfDay = (hour: Int, minute: Int)
