//
// Pet Therapy.
//

import XCTest
import WindowsDetector

@testable import OnScreen

final class DesktopObstaclesTests: XCTestCase {
    
    let habitat = CGRect(x: 0, y: 0, width: 1000, height: 1000)    
    
    func testRoofIsProperlyGeneratedFromWindow() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        let thickness: CGFloat = 20
        let obstacles = rect.obstacles(borderThickness: thickness)
        XCTAssertEqual(obstacles.count, 1)
        
        let top = obstacles[0]
        XCTAssertEqual(top.minX, 0)
        XCTAssertEqual(top.minY, 0)
        XCTAssertEqual(top.width, 300)
        XCTAssertEqual(top.height, thickness)
    }    
}
