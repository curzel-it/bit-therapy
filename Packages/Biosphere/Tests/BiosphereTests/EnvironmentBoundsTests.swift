//
// Pet Therapy.
//

import XCTest
import Squanch
import SwiftUI

@testable import Biosphere

class EnvironmentBoundsNoSafeAreaTests: XCTestCase {
    
    let env = Environment(
        bounds: CGRect(x: 0, y: 0, width: 1000, height: 1000),
        safeAreaInsets: EdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 40)
    )
    
    func testTopBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.topBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, -1000)
        XCTAssertEqual(bound?.frame.maxX, 1940)
        XCTAssertEqual(bound?.frame.minY, -1000)
        XCTAssertEqual(bound?.frame.maxY, 0)
    }
    
    func testRightBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.rightBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, 940)
        XCTAssertEqual(bound?.frame.maxX, 1940)
        XCTAssertEqual(bound?.frame.minY, 0)
        XCTAssertEqual(bound?.frame.maxY, 960)
    }
    
    func testBottomBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.bottomBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, -1000)
        XCTAssertEqual(bound?.frame.maxX, 1940)
        XCTAssertEqual(bound?.frame.minY, 960)
        XCTAssertEqual(bound?.frame.maxY, 1960)
    }
    
    func testLeftBoundProperlyPlaced() {
        let bound = env.children.first { $0.id == Hotspot.leftBound.rawValue }
        XCTAssertNotNil(bound)
        XCTAssertEqual(bound?.frame.minX, -1000)
        XCTAssertEqual(bound?.frame.maxX, 0)
        XCTAssertEqual(bound?.frame.minY, 0)
        XCTAssertEqual(bound?.frame.maxY, 960)
    }
}
