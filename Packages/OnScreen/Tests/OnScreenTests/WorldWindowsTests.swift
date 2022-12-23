import XCTest
import Yage
import YageLive

@testable import OnScreen

class OnScreenWindowsTests: XCTestCase {
    var world: LiveWorld!
    var entity1: Entity!
    var entity2: Entity!
    var windows: OnScreenWindows!

    override func setUp() {
        let baseSize = CGRect(origin: .zero, size: .init(square: 100))

        entity1?.kill()
        entity2?.kill()
        world?.kill()
        windows?.kill()

        world = LiveWorld(name: "test", bounds: CGRect(size: .init(square: 1000)))
        entity1 = Entity(species: .agent, id: "test1", frame: baseSize, in: world.state.bounds)
        entity2 = Entity(species: .agent, id: "test2", frame: baseSize, in: world.state.bounds)
        windows = OnScreenWindows(for: [world])
    }

    func testWindowsAreSpawnedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, world.renderableChildren)

        world.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.world.renderableChildren)

            self.world.state.children.append(self.entity2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.windows.windows.count, self.world.renderableChildren)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(windows.windows.count, world.renderableChildren)
    }

    func testClosedWindowsAreRemovedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, world.renderableChildren)

        world.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.world.renderableChildren)

            self.entity1.kill()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(windows.windows.count, world.renderableChildren)
    }
}

private extension LiveWorld {
    var renderableChildren: Int {
        state.children
            .filter { $0.sprite != nil && $0.isAlive }
            .count
    }
}
