//
// Pet Therapy.
//

import XCTest
import WindowsDetector

@testable import OnScreen

final class DesktopObstaclesTests: XCTestCase {
    
    let habitat = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    
    func testProperlySizedAndPositionedWindowsAreValidObstacles() {
        let detector = DesktopObstaclesService(habitatBounds: habitat, petSize: 10)
        let window = TestWindow(
            id: 1234,
            frame: CGRect(x: 1, y: 11, width: 99, height: 200),
            processName: "Valid Process"
        )
        XCTAssertTrue(detector.isValidObstacle(window: window))
    }
    
    func testWindowsTooHighUpAreNotValidObstacles() {
        let detector = DesktopObstaclesService(habitatBounds: habitat, petSize: 10)
        let window = TestWindow(
            id: 1234,
            frame: CGRect(x: 1, y: 2, width: 99, height: 200),
            processName: "Valid Process"
        )
        XCTAssertFalse(detector.isValidObstacle(window: window))
    }
    
    func testDesktopPetsWindowsAreNotValidObstacles() {
        let detector = DesktopObstaclesService(habitatBounds: habitat, petSize: 0)
        let window = TestWindow(
            id: 1234,
            frame: CGRect(x: 1, y: 2, width: 99, height: 200),
            processName: "Desktop Pets"
        )
        XCTAssertFalse(detector.isValidObstacle(window: window))
    }
    
    func testRoofIsProperlyGeneratedFromWindow() {
        let window = TestWindow(
            id: 1234,
            frame: CGRect(x: 1, y: 2, width: 99, height: 200),
            processName: nil
        )
        let roof = WindowRoof(of: window, in: habitat)
        XCTAssertEqual(roof.id, "window-1234")
        XCTAssertEqual(roof.frame.minX, window.frame.minX)
        XCTAssertEqual(roof.frame.minY, window.frame.minY)
        XCTAssertEqual(roof.frame.width, window.frame.width)
        XCTAssertEqual(roof.frame.height, 100)
    }
}

private struct TestWindow: Window {
    
    let id: Int
    let frame: CGRect
    let processName: String?
}
