//
// Pet Therapy.
//

import XCTest
import WindowsDetector

@testable import OnScreen

final class DesktopObstaclesTests: XCTestCase {
    
    let habitat = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    
    func testWindowsTooHighUpAreNotValidObstacles() {
        let detector = DesktopObstaclesService(habitatBounds: habitat, petSize: 10)
        let rect = CGRect(x: 1, y: 2, width: 99, height: 200)
        XCTAssertFalse(detector.isValidRoof(frame: rect))
    }
    
    func testWindowsWithValidProcessAndFrameAreValid() {
        let detector = DesktopObstaclesService(habitatBounds: habitat, petSize: 10)
        let rect = CGRect(x: 1, y: 200, width: 99, height: 200)
        XCTAssertTrue(detector.isValidRoof(frame: rect))
    }
    
    func testRoofIsProperlyGeneratedFromWindow() {
        let rect = CGRect(x: 1, y: 200, width: 99, height: 200)
        let roof = rect.roofRect()
        XCTAssertEqual(roof.minX, rect.minX)
        XCTAssertEqual(roof.minY, rect.minY)
        XCTAssertEqual(roof.width, rect.width)
        XCTAssertEqual(roof.height, 50)
    }    
}
