import XCTest

@testable import Yage

class BounceOnLateralCollisionsTests: XCTestCase {
    private let testEnv = World(name: "test", bounds: CGRect(x: 0, y: 0, width: 100, height: 100))
    private var movement: LinearMovement!
    private var bounce: BounceOnLateralCollisions!

    private lazy var testEntity: Entity = {
        let entity = Entity(
            species: .agent,
            id: "entity",
            frame: CGRect(x: 50, y: 0, width: 10, height: 10),
            in: testEnv
        )
        bounce = BounceOnLateralCollisions()
        entity.install(bounce)
        movement = LinearMovement()
        entity.install(movement)
        testEnv.children.append(entity)
        return entity
    }()
    
    func testDoesNotBounceWhenHittingANonStaticEntity() {
        testEntity.frame.origin = CGPoint(x: 50, y: 0)
        testEntity.direction = .init(dx: 1, dy: 0)
        let testRight = Entity(
            species: .agent,
            id: "right",
            frame: CGRect(
                x: testEntity.frame.maxX - 5,
                y: 0, width: 50, height: 50
            ),
            in: testEnv
        )
        testEnv.children.append(testRight)

        let collisions = testEntity.collisions(with: [testRight])
        let angle = bounce.bouncingAngle(from: 0, with: collisions)
        XCTAssertEqual(angle, nil)

        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, 1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }
    
    func testBouncesToLeftWhenHittingRight() {
        testEntity.frame.origin = CGPoint(x: 50, y: 0)
        testEntity.direction = .init(dx: 1, dy: 0)
        let testRight = Entity(
            species: .agent,
            id: "right",
            frame: CGRect(
                x: testEntity.frame.maxX - 5,
                y: 0, width: 50, height: 50
            ),
            in: testEnv
        )
        testRight.isStatic = true
        testEnv.children.append(testRight)

        let collisions = testEntity.collisions(with: [testRight])
        let angle = bounce.bouncingAngle(from: 0, with: collisions)
        XCTAssertEqual(angle, CGFloat.pi)

        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, -1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }

    func testBouncesToRightWhenHittingLeft() {
        testEntity.frame.origin = CGPoint(x: 50, y: 0)
        testEntity.direction = .init(dx: -1, dy: 0)
        let testLeft = Entity(
            species: .agent,
            id: "left",
            frame: CGRect(
                x: testEntity.frame.minX - 50 + 5,
                y: 0, width: 50, height: 50
            ),
            in: testEnv
        )
        testLeft.isStatic = true
        testEnv.children.append(testLeft)

        let collisions = testEntity.collisions(with: [testLeft])
        let angle = bounce.bouncingAngle(from: .pi, with: collisions)
        XCTAssertEqual(angle, 0)

        testEntity.update(with: collisions, after: 0.01)
        XCTAssertEqual(testEntity.direction.dx, 1, accuracy: 0.00001)
        XCTAssertEqual(testEntity.direction.dy, 0, accuracy: 0.00001)
    }
}
