//
// Pet Therapy.
//

import XCTest

@testable import Physics

class BounceOnLateralCollisionTests: XCTestCase {
    
    func testBouncesToLeftWhenHittingRight() {
        let entity = PhysicsEntity(
            id: "entity",
            frame: CGRect(x: 0, y: 0, width: 10, height: 10),
            in: .zero
        )
        entity.set(direction: .init(dx: 1, dy: 0))
        
        let other = PhysicsEntity(
            id: Hotspot.rightBound.rawValue,
            frame: CGRect(x: 8, y: 0, width: 4, height: 100),
            in: .zero
        )
        let collisions = entity.collisions(with: [other])
        
        let bounce = BounceOnLateralCollision(with: entity)
        let angle = bounce.bouncingAngle(collisions: collisions)
        XCTAssertEqual(angle, .pi)
        
        entity.capabilities = [bounce]
        entity.update(with: collisions, after: 0.01)
        XCTAssertEqual(entity.direction.dx, -1, accuracy: 0.00001)
        XCTAssertEqual(entity.direction.dy, 0, accuracy: 0.00001)
    }
    
    func testBouncesToRightWhenHittingLeft() {
        let entity = PhysicsEntity(
            id: "entity",
            frame: CGRect(x: 0, y: 0, width: 10, height: 10),
            in: .zero
        )
        entity.set(direction: .init(dx: -1, dy: 0))
        
        let other = PhysicsEntity(
            id: Hotspot.leftBound.rawValue,
            frame: CGRect(x: -2, y: 0, width: 4, height: 100),
            in: .zero
        )
        let collisions = entity.collisions(with: [other])
        
        let bounce = BounceOnLateralCollision(with: entity)
        let angle = bounce.bouncingAngle(collisions: collisions)
        XCTAssertEqual(angle, 0)
        
        entity.capabilities = [bounce]
        entity.update(with: collisions, after: 0.01)
        XCTAssertEqual(entity.direction.dx, 1, accuracy: 0.00001)
        XCTAssertEqual(entity.direction.dy, 0, accuracy: 0.00001)
    }
}
