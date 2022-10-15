import XCTest
import SwiftUI

@testable import Yage

class GravityTests: XCTestCase {
    
    var env: World!
    var player: Entity!
    
    override func setUp() async throws {
        env?.children.forEach { $0.kill() }
        env = World(bounds: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        
        player = Entity(
            id: "player",
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            in: env.bounds
        )
        player.speed = 1
        player.set(direction: CGVector(dx: 1, dy: 0))
        player.set(state: .move)
        player.install(LinearMovement())
        player.install(Gravity())
        env.children.append(player)
    }
    
    func testEntitiesCanFallToGround() {
        let ground1 = Entity(
            id: "ground1",
            frame: CGRect(x: 0, y: 100, width: 200, height: 50),
            in: env.bounds
        )
        env.children.append(ground1)
        
        let goRight = CGVector(dx: 1, dy: 0)
        player.speed = 1
        player.set(origin: CGPoint(x: 50, y: 0))
        player.set(direction: goRight)
        player.set(state: .move)
        
        env.update(after: 0.1)
        XCTAssertEqual(player.state, .freeFall)
        XCTAssertEqual(player.direction, Gravity.fallDirection)
        
        for _ in 0..<70 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
        XCTAssertEqual(player.frame.minY, ground1.frame.minY - player.frame.height)
        XCTAssertEqual(player.direction, goRight)
    }
    
    func testEntitiesRaiseAboveGround() {
        let ground1 = Entity(
            id: "ground1",
            frame: CGRect(x: 0, y: 100, width: 200, height: 50),
            in: env.bounds
        )
        env.children.append(ground1)
        
        let goRight = CGVector(dx: 1, dy: 0)
        player.speed = 1
        player.install(BounceOnLateralCollisions())
        player.set(origin: CGPoint(x: 50, y: 60))
        player.set(direction: goRight)
        player.set(state: .move)
        
        env.update(after: 0.1)
        XCTAssertEqual(player.state, .move)
        XCTAssertEqual(player.frame.minY, ground1.frame.minY - player.frame.height)
    }
    
    func testLadder() {
        let ground1 = Entity(
            id: "ground1",
            frame: CGRect(x: 369, y: 354, width: 250, height: 48),
            in: env.bounds
        )
        env.children.append(ground1)
        
        let ground2 = Entity(
            id: "ground2",
            frame: CGRect(x: 396, y: 402, width: 687, height: 70),
            in: env.bounds
        )
        env.children.append(ground2)
        
        let goRight = CGVector(dx: 1, dy: 0)
        player.speed = 1
        player.install(BounceOnLateralCollisions())
        player.set(size: CGSize(width: 70, height: 70))
        player.set(origin: CGPoint(x: ground1.frame.maxX-40, y: ground1.frame.minY - player.frame.height))
        player.set(direction: goRight)
        player.set(state: .move)
        
        for _ in 0..<20 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
        for _ in 20..<51 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .freeFall)
        for _ in 51..<112 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)
        for _ in 112..<200 { env.update(after: 0.1) }
        XCTAssertEqual(player.state, .move)        
    }
}
