import Schwifty
import XCTest

@testable import Yage

class RadiansTests: XCTestCase {
    func testCorrectRadiansFromVector() {
        XCTAssertEqual(CGVector(dx: 0, dy: 0).radians, .pi * 0.0)
        XCTAssertEqual(CGVector(dx: 1, dy: 0).radians, .pi * 0.0)
        XCTAssertEqual(CGVector(dx: 0, dy: 1).radians, .pi * 0.5)
        XCTAssertEqual(CGVector(dx: -1, dy: 0).radians, .pi * 1.0)
        XCTAssertEqual(CGVector(dx: 0, dy: -1).radians, .pi * 1.5)
    }

    func testCorrectVectorFromRadians() {
        XCTAssertEqual(.pi * 0.0, CGVector(dx: 0, dy: 0).radians)
        XCTAssertEqual(.pi * 0.0, CGVector(dx: 1, dy: 0).radians)
        XCTAssertEqual(.pi * 0.5, CGVector(dx: 0, dy: 1).radians)
        XCTAssertEqual(.pi * 1.0, CGVector(dx: -1, dy: 0).radians)
        XCTAssertEqual(.pi * 1.5, CGVector(dx: 0, dy: -1).radians)
    }

    func testCanConvertDegreesToRadians() {
        XCTAssertEqual(degreesToRadians(0), 0)
        XCTAssertEqual(degreesToRadians(90), .pi * 0.5)
        XCTAssertEqual(degreesToRadians(180), .pi * 1.0)
        XCTAssertEqual(degreesToRadians(270), .pi * 1.5)
        XCTAssertEqual(degreesToRadians(360), 0)
        XCTAssertEqual(degreesToRadians(720), 0)
        XCTAssertEqual(degreesToRadians(-123), degreesToRadians(360 - 123))
        XCTAssertEqual(degreesToRadians(360 + 123), degreesToRadians(123))
    }
}
