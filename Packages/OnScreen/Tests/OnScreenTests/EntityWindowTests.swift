import XCTest
import Yage
import YageLive

@testable import OnScreen

class EntityWindowTests: XCTestCase {
    var entity: Entity!
    var world: LiveWorld!
    var window: EntityWindow!

    override func setUp() {
        entity?.kill()
        world?.kill()
        window?.close()

        world = LiveWorld(name: "test", bounds: CGRect(size: .init(square: 1000)))
        entity = Entity(
            species: .agent,
            id: "test",
            frame: CGRect(origin: .zero, size: .init(square: 100)),
            in: world.state.bounds
        )
        world.state.children.append(entity)
        window = EntityWindow(representing: entity)
        window.show()
    }

    func testWindowKeepsReferenceToEntity() {
        XCTAssertEqual(window.entity, entity)
    }

    func testKillingEntityClosesWindow() {
        let expectation = expectation(description: "")
        XCTAssertTrue(window.isVisible)
        entity.kill()
        world.loop()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertFalse(window?.isVisible ?? true)
    }

    func testUpdatingEntityFrameUpdatesWindowFrame() {
        world.loop()
        XCTAssertEqual(window.expectedFrame.size, entity.frame.size)
        entity.frame.size = .init(square: 200)
        world.loop()
        XCTAssertEqual(window.expectedFrame.size, entity.frame.size)
    }

    func testAfterBeingClosedWindowFrameStopsUpdating() {
        let lastSize = entity.frame.size
        world.loop()
        XCTAssertEqual(window.expectedFrame.size, lastSize)
        window.close()
        entity.frame.size = .init(square: 200)
        world.loop()
        XCTAssertEqual(window.expectedFrame.size, lastSize)
    }
}

extension LiveWorld: Equatable {
    public static func == (lhs: LiveWorld, rhs: LiveWorld) -> Bool {
        lhs.name == rhs.name
    }
}
