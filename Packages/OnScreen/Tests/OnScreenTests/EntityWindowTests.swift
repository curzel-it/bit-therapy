import XCTest
import Yage

@testable import OnScreen

class EntityWindowTests: XCTestCase {
    
    var entity: Entity!
    var world: LiveWorld!
    var window: EntityWindow!
    
    override func setUp() {
        entity?.kill()
        world?.kill()
        window?.close()
        
        world = LiveWorld(
            id: "test",
            bounds: CGRect(size: .init(square: 1000))
        )
        entity = Entity(
            id: "test",
            frame: CGRect(origin: .zero, size: .init(square: 100)),
            in: world.state.bounds
        )
        world.state.children.append(entity)
        window = EntityWindow(representing: entity, in: world)
        window.show()
    }
    
    func testWindowKeepsReferenceToEntity() {
        XCTAssertEqual(window.entity, entity)
    }
    
    func testWindowKeepsReferenceToWorld() {
        XCTAssertEqual(window.world, world)
    }
    
    func testKillingEntityClosesWindow() {
        let expectation = expectation(description: "")
        
        XCTAssertTrue(window.isVisible)
        entity.kill()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertFalse(self.window?.isVisible ?? true)
    }
    
    func testUpdatingEntityFrameUpdatesWindowFrame() {
        let expectation = expectation(description: "")
        
        XCTAssertEqual(window.expectedFrame.size, entity.frame.size)
        entity.set(size: .init(square: 200))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(window.expectedFrame.size, entity.frame.size)
    }
    
    func testAfterBeingClosedWindowFrameStopsUpdating() {
        let expectation = expectation(description: "")
        
        let lastSize = entity.frame.size
        XCTAssertEqual(window.expectedFrame.size, lastSize)
        window.close()
        entity.set(size: .init(square: 200))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(window.expectedFrame.size, lastSize)
    }
}

extension LiveWorld: Equatable {
    public static func == (lhs: LiveWorld, rhs: LiveWorld) -> Bool {
        lhs.id == rhs.id
    }
}
