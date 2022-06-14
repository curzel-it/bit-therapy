//
// Pet Therapy.
//

import XCTest

@testable import Physics

class CollisionsTests: XCTestCase {
    
    func testNonOverlappingEntitiesDoNotCollide() throws {
        let first = PhysicsEntity(id: "first", frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let second = PhysicsEntity(id: "second", frame: CGRect(x: 20, y: 20, width: 10, height: 10))
        XCTAssertEqual(first.collisions(with: [second]).count, 0)
    }
    
    func testOverlappingEntitiesDoCollide() throws {
        let first = PhysicsEntity(id: "first", frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let bottomRightOverlap = PhysicsEntity(
            id: "bottomRightOverlap",
            frame: CGRect(x: 1, y: 1, width: 10, height: 10)
        )
        XCTAssertEqual(first.collisions(with: [bottomRightOverlap]).count, 2)
        
        let bottomOverlap = PhysicsEntity(
            id: "bottomOverlap",
            frame: CGRect(x: 1, y: 5, width: 6, height: 6)
        )
        XCTAssertEqual(first.collisions(with: [bottomOverlap]).count, 1)
    }
    
    func testEphemeralEntitiesCanStillCollide() throws {
        let first = PhysicsEntity(id: "first", frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        first.isEphemeral = true
        let second = PhysicsEntity(id: "second", frame: CGRect(x: 1, y: 1, width: 10, height: 10))
        second.isEphemeral = true
        let collisions = first.collisions(with: [second])
        XCTAssertEqual(collisions.count, 2)
    }
    
    func testCollisionSideIsProperlyDetected() throws {
        let first = PhysicsEntity(id: "first", frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let top = PhysicsEntity(
            id: "top",
            frame: CGRect(x: 3, y: -2, width: 4, height: 4)
        )
        let topCollisions = top.collisions(with: [first])
        XCTAssertEqual(topCollisions.count, 1)
        XCTAssertEqual(topCollisions.first?.mySide, .bottom)
                
        let right = PhysicsEntity(
            id: "right",
            frame: CGRect(x: 8, y: 3, width: 4, height: 4)
        )
        let rightCollisions = right.collisions(with: [first])
        XCTAssertEqual(rightCollisions.count, 1)
        XCTAssertEqual(rightCollisions.first?.mySide, .left)
        
        let bottom = PhysicsEntity(
            id: "bottom",
            frame: CGRect(x: 3, y: 8, width: 4, height: 4)
        )
        let bottomCollisions = bottom.collisions(with: [first])
        XCTAssertEqual(bottomCollisions.count, 1)
        XCTAssertEqual(bottomCollisions.first?.mySide, .top)
        
        let left = PhysicsEntity(
            id: "left",
            frame: CGRect(x: -2, y: 3, width: 4, height: 4)
        )
        let leftCollisions = left.collisions(with: [first])
        XCTAssertEqual(leftCollisions.count, 1)
        XCTAssertEqual(leftCollisions.first?.mySide, .right)
        
        let otherCollisions = first.collisions(with: [top, right, bottom, left])
        XCTAssertEqual(otherCollisions.count, 4)
    }
}
