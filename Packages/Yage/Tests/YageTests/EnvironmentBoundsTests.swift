import XCTest
import SwiftUI

@testable import Yage

class EnvironmentBoundsNoSafeAreaTests: XCTestCase {
    let env = World(
        bounds: CGRect(x: 0, y: 50, width: 400, height: 900)
    )
    
    func testTopBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.topBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, -1000)
        XCTAssertEqual(bound?.frame.maxX, 1400)
        XCTAssertEqual(bound?.frame.minY, -950)
        XCTAssertEqual(bound?.frame.maxY, 50)
    }
    
    func testRightBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.rightBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, 400)
        XCTAssertEqual(bound?.frame.maxX, 1400)
        XCTAssertEqual(bound?.frame.minY, -1000)
        XCTAssertEqual(bound?.frame.maxY, 1900)
    }
    
    func testBottomBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.bottomBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, -1000)
        XCTAssertEqual(bound?.frame.maxX, 1400)
        XCTAssertEqual(bound?.frame.minY, 950)
        XCTAssertEqual(bound?.frame.maxY, 1950)
    }
    
    func testLeftBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.leftBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, -1000)
        XCTAssertEqual(bound?.frame.maxX, 0)
        XCTAssertEqual(bound?.frame.minY, -1000)
        XCTAssertEqual(bound?.frame.maxY, 1900)
    }
}
