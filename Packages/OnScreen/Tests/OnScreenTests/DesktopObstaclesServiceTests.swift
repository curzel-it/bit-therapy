import XCTest
import Yage
import YageLive

@testable import OnScreen

final class DesktopObstaclesServiceTests: XCTestCase {
    let world = LiveWorld(
        name: "test",
        bounds: CGRect(size: .init(square: 1000))
    )

    lazy var service: DesktopObstaclesService = .init(world: world)

    func testRoofIsProperlyGeneratedFromWindow() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        let thickness: CGFloat = 20
        let obstacles = service.obstacles(from: rect, borderThickness: thickness)
        XCTAssertEqual(obstacles.count, 1)

        let top = obstacles[0]
        XCTAssertEqual(top.minX, 0)
        XCTAssertEqual(top.minY, 0)
        XCTAssertEqual(top.width, 300)
        XCTAssertEqual(top.height, thickness)
    }
}
