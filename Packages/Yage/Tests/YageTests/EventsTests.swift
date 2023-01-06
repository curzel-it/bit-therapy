import XCTest

@testable import Yage

class EventsTests: XCTestCase {
    func testScheduleIsProperlyConvertedToString() {
        XCTAssertEqual(
            EventSchedule(hour: 0, minute: 0).description,
            "Every day at 00:00"
        )
        XCTAssertEqual(
            EventSchedule(hour: 12, minute: 1).description,
            "Every day at 12:01"
        )
        XCTAssertEqual(
            EventSchedule(hour: 20, minute: 2).description,
            "Every day at 20:02"
        )
        XCTAssertEqual(
            EventSchedule(hour: 24, minute: 3).description,
            "Every day at 24:03"
        )
    }

    func testTimeOfDayScheduleReturnsProperDate() {
        let date = EventSchedule(hour: 23, minute: 59).nextDate()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        XCTAssertEqual(components.hour, 23)
        XCTAssertEqual(components.minute, 59)

        let today = Calendar.current.dateComponents([.day], from: Date()).day
        XCTAssertEqual(components.day, today)
    }

    func testTimeOfDayIntervalFromString() {
        XCTAssertEqual(
            EventSchedule(from: "daily:00:00")?.description,
            "Every day at 00:00"
        )
        XCTAssertEqual(
            EventSchedule(from: "daily:0:0")?.description,
            "Every day at 00:00"
        )
        XCTAssertEqual(
            EventSchedule(from: "daily:12:01")?.description,
            "Every day at 12:01"
        )
        XCTAssertEqual(
            EventSchedule(from: "daily:20:02")?.description,
            "Every day at 20:02"
        )
        XCTAssertEqual(
            EventSchedule(from: "daily:24:03")?.description,
            "Every day at 24:03"
        )
        XCTAssertNil(EventSchedule(from: "daily:25:03"))
        XCTAssertNil(EventSchedule(from: "daily:23:99"))
        XCTAssertNil(EventSchedule(from: "daily:25:99"))
    }
}
