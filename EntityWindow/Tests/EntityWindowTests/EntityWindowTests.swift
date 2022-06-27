//
// Pet Therapy.
//

import XCTest
import Biosphere

@testable import EntityWindow

class EntityWindowTests: XCTestCase {
    
    var entity: Entity!
    var habitat: HabitatViewModel!
    var window: EntityWindow!
    
    override func setUp() {
        entity?.kill()
        habitat?.kill(animated: false)
        window?.close()
        
        habitat = HabitatViewModel(id: "test")
        entity = Entity(
            id: "test",
            frame: CGRect(origin: .zero, size: .init(square: 100)),
            in: habitat.state.bounds
        )
        habitat.state.children.append(entity)
        window = EntityWindow(representing: entity, in: habitat)
    }
    
    func testWindowKeepsReferenceToEntity() {
        XCTAssertEqual(window.entity, entity)
    }
    
    func testWindowKeepsReferenceToHabitat() {
        XCTAssertEqual(window.habitat, habitat)
    }
    
    func testKillingEntityClosesWindow() {
        window.show()
        XCTAssertTrue(window.isVisible)
        entity.kill()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.window?.isVisible ?? true)
        }
    }
    
    func testResizingEntityResizesWindow() {
        window.show()
        XCTAssertEqual(self.window?.frame.size, entity.frame.size)
        entity.set(size: .init(square: 200))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.window?.frame.size, self.entity?.frame.size)
        }
    }
    
    func testAfterBeingClosedWindowStopsResizing() {
        window.show()
        let lastSize = entity.frame.size
        XCTAssertEqual(self.window?.frame.size, lastSize)
        window.close()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.entity?.set(size: .init(square: 200))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.window?.frame.size, lastSize)
            }
        }
    }
}
