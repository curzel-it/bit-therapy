import XCTest

@testable import Yage

class EventsTests: XCTestCase {
    
    func testScheduleIsProperlyConvertedToString() {
        XCTAssertEqual(
            EventSchedule.timeOfDay(hour: 0, minute: 0).description,
            "Every day at 00:00"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(hour: 12, minute: 1).description,
            "Every day at 12:01"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(hour: 20, minute: 2).description,
            "Every day at 20:02"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(hour: 24, minute: 3).description,
            "Every day at 24:03"
        )
    }
    
    func testTimeOfDayScheduleReturnsProperDate() {
        let date = EventSchedule.timeOfDay(hour: 23, minute: 59).nextDate()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        XCTAssertEqual(components.hour, 23)
        XCTAssertEqual(components.minute, 59)
        
        let today = Calendar.current.dateComponents([.day], from: Date()).day
        XCTAssertEqual(components.day, today    )
    }
}
