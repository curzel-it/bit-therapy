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
        XCTAssertEqual(
            EventSchedule.every(timeInterval: 6).description,
            "Every ~0.1 minutes"
        )
        XCTAssertEqual(
            EventSchedule.every(timeInterval: 60).description,
            "Every ~1.0 minutes"
        )
    }

    func testTimeOfDayScheduleReturnsProperDate() {
        let date = EventSchedule.timeOfDay(hour: 23, minute: 59).nextDate()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        XCTAssertEqual(components.hour, 23)
        XCTAssertEqual(components.minute, 59)

        let today = Calendar.current.dateComponents([.day], from: Date()).day
        XCTAssertEqual(components.day, today)
    }

    func testTimeOfDayIntervalFromString() {
        XCTAssertEqual(
            EventSchedule.timeOfDay(from: "daily:00:00")?.description,
            "Every day at 00:00"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(from: "daily:0:0")?.description,
            "Every day at 00:00"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(from: "daily:12:01")?.description,
            "Every day at 12:01"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(from: "daily:20:02")?.description,
            "Every day at 20:02"
        )
        XCTAssertEqual(
            EventSchedule.timeOfDay(from: "daily:24:03")?.description,
            "Every day at 24:03"
        )
        XCTAssertNil(EventSchedule.timeOfDay(from: "daily:25:03"))
        XCTAssertNil(EventSchedule.timeOfDay(from: "daily:23:99"))
        XCTAssertNil(EventSchedule.timeOfDay(from: "daily:25:99"))
    }

    func testEveryIntervalFromString() {
        XCTAssertEqual(
            EventSchedule.everyTimeInterval(from: "every:minutes:0.1")?.description,
            "Every ~0.1 minutes"
        )
        XCTAssertEqual(
            EventSchedule.everyTimeInterval(from: "every:minutes:1")?.description,
            "Every ~1.0 minutes"
        )
        XCTAssertEqual(
            EventSchedule.everyTimeInterval(from: "every:hours:2.5")?.description,
            "Every ~150.0 minutes"
        )
        XCTAssertNil(EventSchedule.everyTimeInterval(from: "every:minutes:0"))
        XCTAssertNil(EventSchedule.everyTimeInterval(from: "every:minutes:-10"))
    }
}
