//
// Pet Therapy.
//

import XCTest

@testable import Squanch

private let dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS"

class DateParseAndFormatTests: XCTestCase {
    
    func testReturnsNilWhenParsingMalformedDateString() {
        XCTAssertNil(Date.from(nil, using: dateFormat))
        XCTAssertNil(Date.from("abcd", using: dateFormat))
    }
    
    func testDateParsedCorretly() {
        let date = Date.from("2020-01-02T12:34:56.123", using: dateFormat)
        XCTAssertNotNil(date)
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: date!
        )
        XCTAssertEqual(components.second, 56)
        XCTAssertEqual(components.minute, 34)
        XCTAssertEqual(components.hour, 12)
        XCTAssertEqual(components.day, 2)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2020)
    }
    
    func testDateFormattedCorretly() {
        let dateString = "2020-01-02T12:34:56.123"
        let date = Date.from("2020-01-02T12:34:56.123", using: dateFormat)
        XCTAssertEqual(date?.string(dateFormat), dateString)
    }
}
