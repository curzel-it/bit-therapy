//
// Pet Therapy.
//

import XCTest

@testable import Physics

class BounceOffLateralBoundsTests: XCTestCase {
    
    private let testBounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    private lazy var testRightBound = { rightBound(in: testBounds) }()
    private lazy var testLeftBound = { leftBound(in: testBounds) }()
    
    private var testEntity: PhysicsEntity!
    private var bounce: BounceOffLateralBounds!
    
    override func setUp() {
        testEntity = PhysicsEntity(
            id: "entity",
            frame: CGRect(x: 10, y: 10, width: 10, height: 10),
            in: testBounds
        )
        bounce = BounceOffLateralBounds(with: testEntity)
        testEntity.capabilities = [bounce]
    }
    
    func testBouncesToLeftWhenHittingRight() {
        testEntity.set(
            origin: CGPoint(
                x: testRightBound.frame.origin.x - testEntity.frame.width,
                y: 0
            )
        )
        testEntity.set(direction: .init(dx: 1, dy: 0))
        
        let collisions = testEntity.collisions(with: [testRightBound])
        let angle = bounce.bouncingAngle(collisions: collisions)
        XCTAssertEqual(angle, .pi)
        
        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, -1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }
    
    func testBouncesToRightWhenHittingLeft() {
        testEntity.set(
            origin: CGPoint(
                x: testLeftBound.frame.maxX,
                y: 0
            )
        )
        testEntity.set(direction: .init(dx: -1, dy: 0))
        
        let collisions = testEntity.collisions(with: [testLeftBound])
        let angle = bounce.bouncingAngle(collisions: collisions)
        XCTAssertEqual(angle, 0)
        
        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, 1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }
}
