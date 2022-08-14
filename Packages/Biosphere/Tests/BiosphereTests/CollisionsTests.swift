//
// Pet Therapy.
//

import XCTest

@testable import Biosphere

class CollisionsTests: XCTestCase {
    
    private let testBounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    func testMultipleCollisionsCanBeDetected() {
        let main = Entity(
            id: "main",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let others: [Entity] = (0..<12).map { (count: Int) in
            Entity(
                id: "other-\(count)",
                frame: CGRect(
                    x: 0.1 * Double(count),
                    y: 0, width: 1, height: 1
                ),
                in: testBounds
            )
        }
        let collisions = main.collisions(with: others)
        XCTAssertEqual(collisions.count, 11)
        
        let moreCollisions = main.collisions(with: [main] + others)
        XCTAssertEqual(moreCollisions.count, 11)
    }
    
    func testDistantEntitiesDoNotCollide() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 2, y: 2, width: 1, height: 1),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        XCTAssertNil(collision)
    }
    
    func testEqualEntitiesDoCollide() {
        let entity = Entity(id: "someEntity", frame: .zero, in: testBounds)
        let collision = entity.collision(with: entity)
        XCTAssertNotNil(collision)
    }
    
    func testEntitiesWithSameFrameCollide() {
        let entity1 = Entity(id: "entity1", frame: .zero, in: testBounds)
        let entity2 = Entity(id: "entity2", frame: .zero, in: testBounds)
        let collision = entity1.collision(with: entity2)
        XCTAssertNotNil(collision)
    }
    
    func testEntitiesSharingOneCornerCollide() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 1, y: 1, width: 1, height: 1),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let expectedIntersection = CGRect(x: 1, y: 1, width: 0, height: 0)
        XCTAssertNotNil(collision)
        XCTAssertEqual(collision?.intersection ?? .zero, expectedIntersection)
    }
    
    func testEntitiesSharingOneSideCollide() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 1, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let expectedIntersection = CGRect(x: 1, y: 0, width: 0, height: 1)
        XCTAssertNotNil(collision)
        XCTAssertEqual(collision?.intersection ?? .zero, expectedIntersection)
    }
    
    func testOverlappingEntitiesCollide() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 2, height: 2),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 1, y: 1, width: 2, height: 2),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let expectedIntersection = CGRect(x: 1, y: 1, width: 1, height: 1)
        XCTAssertNotNil(collision)
        XCTAssertEqual(collision?.intersection ?? .zero, expectedIntersection)
    }
    
    func testCollisionWithEphimeralEntitiesAreProperlyMarked() {
        let entity1 = Entity(id: "entity1", frame: .zero, in: testBounds)
        let entity2 = Entity(id: "entity2", frame: .zero, in: testBounds)
        entity2.isEphemeral = true
        let collision = entity1.collision(with: entity2)
        XCTAssertTrue(collision?.isEphemeral ?? false)
    }
    
    func testSidesDetectedWhenSameHeightObjectPerfectlyCollidesOnRight() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 0.9, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let sides = collision?.sides() ?? []
        XCTAssertEqual(sides, [.top, .right, .bottom])
    }
    
    func testSidesDetectedWhenSmallerCollidesOnRight() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 0.9, y: 0.25, width: 1, height: 0.5),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let sides = collision?.sides() ?? []
        XCTAssertEqual(sides, [.right])
    }
    
    func testSidesDetectedWhenLargerCollidesOnRight() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 0.9, y: -1, width: 1, height: 3),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let sides = collision?.sides() ?? []
        XCTAssertEqual(sides, [.top, .right, .bottom])
    }
    
    func testSidesDetectedWhenObjectCollidesOnTopRight() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 0.9, y: 0.9, width: 1, height: 1),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let sides = collision?.sides() ?? []
        XCTAssertEqual(sides, [.top, .right])
    }
    
    func testSidesDetectedWhenObjectCollidesOnBottomRight() {
        let entity1 = Entity(
            id: "entity1",
            frame: CGRect(x: 0, y: 0, width: 1, height: 1),
            in: testBounds
        )
        let entity2 = Entity(
            id: "entity2",
            frame: CGRect(x: 0.9, y: -0.9, width: 1, height: 1),
            in: testBounds
        )
        let collision = entity1.collision(with: entity2)
        let sides = collision?.sides() ?? []
        XCTAssertEqual(sides, [.right, .bottom])
    }
}
