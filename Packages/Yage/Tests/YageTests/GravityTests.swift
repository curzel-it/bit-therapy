import SwiftUI
import XCTest

@testable import Yage

class GravityTests: XCTestCase {
    var env: World!
    var player: Entity!

    override func setUp() async throws {
        env?.children.forEach { $0.kill() }
        env = World(name: "test", bounds: CGRect(x: 0, y: 0, width: 1000, height: 1000))

        player = Entity(
            species: .agent,
            id: "player",
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            in: env
        )
        player.speed = 1
        player.direction = CGVector(dx: 1, dy: 0)
        player.set(state: .move)
        player.install(LinearMovement())
        player.install(Gravity())
        env.children.append(player)
    }
    
    func testNonStaticEntitiesAreNotRecognizedAsGround() {
        let ground1 = Entity(
            species: .agent,
            id: "ground1",
            frame: CGRect(x: 0, y: 100, width: 200, height: 50),
            in: env
        )
        env.children.append(ground1)

        let goRight = CGVector(dx: 1, dy: 0)
        player.speed = 1
        player.frame.origin = CGPoint(x: 50, y: 0)
        player.direction = goRight
        player.set(state: .move)

        env.update(after: 0.1)
        XCTAssertEqual(player.state, .freeFall)
        XCTAssertEqual(player.direction, Gravity.fallDirection)

        for _ in 0 ..< 70 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .freeFall)
    }
    
    func testEntitiesCanFallToGround() {
        let ground1 = Entity(
            species: .agent,
            id: "ground1",
            frame: CGRect(x: 0, y: 100, width: 200, height: 50),
            in: env
        )
        ground1.isStatic = true
        env.children.append(ground1)

        let goRight = CGVector(dx: 1, dy: 0)
        player.speed = 1
        player.frame.origin = CGPoint(x: 50, y: 0)
        player.direction = goRight
        player.set(state: .move)

        env.update(after: 0.1)
        XCTAssertEqual(player.state, .freeFall)
        XCTAssertEqual(player.direction, Gravity.fallDirection)

        for _ in 0 ..< 70 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
        XCTAssertEqual(player.frame.minY, ground1.frame.minY - player.frame.height)
        XCTAssertEqual(player.direction, goRight)
    }

    func testEntitiesRaiseAboveGround() {
        let ground1 = Entity(
            species: .agent,
            id: "ground1",
            frame: CGRect(x: 0, y: 100, width: 200, height: 50),
            in: env
        )
        ground1.isStatic = true
        env.children.append(ground1)

        player.install(BounceOnLateralCollisions())
        player.speed = 1
        player.frame.origin = CGPoint(x: 50, y: 60)
        player.direction = CGVector(dx: 1, dy: 0)
        player.set(state: .move)

        env.update(after: 0.1)
        XCTAssertEqual(player.state, .move)
        XCTAssertEqual(player.frame.minY, ground1.frame.minY - player.frame.height)
    }

    func testLadder() {
        let ground1 = Entity(
            species: .agent,
            id: "ground1",
            frame: CGRect(x: 369, y: 354, width: 250, height: 48),
            in: env
        )
        ground1.isStatic = true
        env.children.append(ground1)

        let ground2 = Entity(
            species: .agent,
            id: "ground2",
            frame: CGRect(x: 396, y: 402, width: 687, height: 70),
            in: env
        )
        ground2.isStatic = true
        env.children.append(ground2)

        player.install(BounceOnLateralCollisions())
        player.speed = 1
        player.frame.size = CGSize(width: 70, height: 70)
        player.frame.origin = CGPoint(
            x: ground1.frame.maxX - 40,
            y: ground1.frame.minY - player.frame.height
        )
        player.direction = CGVector(dx: 1, dy: 0)
        player.set(state: .move)

        for _ in 0 ..< 20 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
        for _ in 20 ..< 51 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .freeFall)
        for _ in 51 ..< 112 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
        for _ in 112 ..< 200 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
    }
}
