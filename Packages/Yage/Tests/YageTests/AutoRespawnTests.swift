import XCTest

@testable import Yage

class AutoRespawnTests: XCTestCase {
    var entity: Entity!
    var respawner: AutoRespawn!
    
    override func setUp() {
        entity = Entity(
            id: "test",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: CGRect(x: 0, y: 0, width: 10, height: 10)
        )
        respawner = AutoRespawn()
        entity.install(respawner)
        respawner.kill()
        respawner.subject = entity
    }
    
    func testOuterBoundsPropertlyCalculated() {
        XCTAssertEqual(respawner.outerBounds().minX, -250)
        XCTAssertEqual(respawner.outerBounds().minY, -250)
        XCTAssertEqual(respawner.outerBounds().width, 510)
        XCTAssertEqual(respawner.outerBounds().height, 510)
    }
    
    func testEntityInsideBoundsIsUntouched() {
        for y in -250..<260 {
            let point = CGPoint(x: 0, y: y)
            print("y: \(point.y) - \(respawner.isWithinBounds(point: point))")
            XCTAssertTrue(respawner.isWithinBounds(point: point))
        }
    }
    
    func testEntityOutsideBoundsIsDetected() {
        XCTAssertFalse(respawner.isWithinBounds(point: CGPoint(x: -251, y: 0)))
        XCTAssertFalse(respawner.isWithinBounds(point: CGPoint(x: 260, y: 0)))
        XCTAssertFalse(respawner.isWithinBounds(point: CGPoint(x: 0, y: -251)))
        XCTAssertFalse(respawner.isWithinBounds(point: CGPoint(x: 0, y: 260)))
    }
}
