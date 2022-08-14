//
// Pet Therapy.
//

import XCTest

@testable import Biosphere

class BounceOffLateralCollisionsTests: XCTestCase {
    
    private let testEnv = Environment(bounds: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    private lazy var testEntity: Entity = {
        let entity = Entity(
            id: "entity",
            frame: CGRect(x: 5, y: 5, width: 1, height: 1),
            in: testEnv.bounds
        )
        bounce = BounceOffLateralCollisions(with: entity)
        entity.capabilities = [bounce]
        testEnv.children.append(entity)
        return entity
    }()
    
    private lazy var testLeft: Entity = {
        let entity = Entity(
            id: "left",
            frame: CGRect(x: 0, y: 5, width: 5, height: 5),
            in: testEnv.bounds
        )
        testEnv.children.append(entity)
        return entity
    }()
    
    private lazy var testRight: Entity = {
        let entity = Entity(
            id: "right",
            frame: CGRect(x: 6, y: 5, width: 5, height: 5),
            in: testEnv.bounds
        )
        testEnv.children.append(entity)
        return entity
    }()
    
    private var bounce: BounceOffLateralCollisions!
    
    override func setUp() async throws {
        testEntity.set(origin: CGPoint(x: 5, y: 5))
    }
    
    func testBouncesToLeftWhenHittingRight() {
        testEntity.set(direction: .init(dx: 1, dy: 0))
        
        let collisions = testEntity.collisions(with: [testRight])
        let angle = bounce.bouncingAngle(collisions: collisions)
        XCTAssertEqual(angle, .pi)
        
        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, -1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }
    
    func testBouncesToRightWhenHittingLeft() {
        testEntity.set(direction: .init(dx: -1, dy: 0))
        
        let collisions = testEntity.collisions(with: [testLeft])
        let angle = bounce.bouncingAngle(collisions: collisions)
        XCTAssertEqual(angle, 0)
        
        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, 1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }
}
