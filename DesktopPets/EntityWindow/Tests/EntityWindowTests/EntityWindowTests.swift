//
// Pet Therapy.
//

import XCTest
import Biosphere
import LiveEnvironment

@testable import EntityWindow

class EntityWindowTests: XCTestCase {
    
    var entity: Entity!
    var habitat: LiveEnvironment!
    var window: EntityWindow!
    
    override func setUp() {
        entity?.kill()
        habitat?.kill(animated: false)
        window?.close()
        
        habitat = LiveEnvironment(
            id: "test",
            bounds: CGRect(size: .init(square: 1000)),
            safeAreaInsets: .init()
        )
        entity = Entity(
            id: "test",
            frame: CGRect(origin: .zero, size: .init(square: 100)),
            in: habitat.state.bounds
        )
        habitat.state.children.append(entity)
        window = EntityWindow(representing: entity, in: habitat)
        window.show()
    }
    
    func testWindowKeepsReferenceToEntity() {
        XCTAssertEqual(window.entity, entity)
    }
    
    func testWindowKeepsReferenceToHabitat() {
        XCTAssertEqual(window.habitat, habitat)
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
