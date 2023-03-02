import SwiftUI
import XCTest

@testable import Yage

class EnvironmentBoundsNoSafeAreaTests: XCTestCase {
    let env = World(name: "test", bounds: CGRect(x: 0, y: 50, width: 400, height: 900))

    func testTopBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.topBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, 0)
        XCTAssertEqual(bound?.frame.maxX, 400)
        XCTAssertEqual(bound?.frame.minY, 0)
        XCTAssertEqual(bound?.frame.maxY, 2)
    }

    func testRightBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.rightBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, 400)
        XCTAssertEqual(bound?.frame.maxX, 402)
        XCTAssertEqual(bound?.frame.minY, 0)
        XCTAssertEqual(bound?.frame.maxY, 900)
    }

    func testBottomBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.bottomBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, 0)
        XCTAssertEqual(bound?.frame.maxX, 400)
        XCTAssertEqual(bound?.frame.minY, 900)
        XCTAssertEqual(bound?.frame.maxY, 902)
    }

    func testLeftBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.leftBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, 0)
        XCTAssertEqual(bound?.frame.maxX, 2)
        XCTAssertEqual(bound?.frame.minY, 0)
        XCTAssertEqual(bound?.frame.maxY, 900)
    }
}
