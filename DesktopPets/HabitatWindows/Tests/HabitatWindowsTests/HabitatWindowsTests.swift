//
// Pet Therapy.
//

import XCTest
import Biosphere

@testable import HabitatWindows

class HabitatWindowsTests: XCTestCase {
    
    var habitat: HabitatViewModel!
    var entity1: Entity!
    var entity2: Entity!
    var windows: HabitatWindows<HabitatViewModel>!
    
    override func setUp() {
        entity1?.kill()
        entity2?.kill()
        habitat?.kill(animated: false)
        windows?.kill()
        
        habitat = HabitatViewModel(
            id: "HabitatWindowsTests",
            bounds: CGRect(size: .init(square: 1000))
        )
        entity1 = Entity(
            id: "test1",
            frame: .init(origin: .zero, size: .init(square: 100)),
            in: habitat.state.bounds
        )
        entity2 = Entity(
            id: "test2",
            frame: .init(origin: .zero, size: .init(square: 100)),
            in: habitat.state.bounds
        )
        windows = HabitatWindows<HabitatViewModel>(
            for: habitat,
            whenAllWindowsHaveBeenClosed: {}
        )
    }
    
    func testWindowsAreSpawnedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, habitat.state.children.count)
                
        habitat.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.habitat.state.children.count)
            
            self.habitat.state.children.append(self.entity2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.windows.windows.count, self.habitat.state.children.count)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.windows.windows.count, self.habitat.state.children.count)
    }
    
    func testClosedWindowsAreRemovedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, habitat.state.children.count)
        
        habitat.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.habitat.state.children.count)
            
            self.entity1.kill()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.windows.windows.count, self.habitat.state.children.count-1)
    }
}
