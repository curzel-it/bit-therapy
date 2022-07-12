//
// Pet Therapy.
//

import XCTest
import Biosphere
import LiveEnvironment

@testable import HabitatWindows

class HabitatWindowsTests: XCTestCase {
    
    var habitat: LiveEnvironment!
    var entity1: Entity!
    var entity2: Entity!
    var windows: HabitatWindows<LiveEnvironment>!
    
    override func setUp() {
        entity1?.kill()
        entity2?.kill()
        habitat?.kill(animated: false)
        windows?.kill()
        
        habitat = LiveEnvironment(
            id: "HabitatWindowsTests",
            bounds: CGRect(size: .init(square: 1000)),
            safeAreaInsets: .init()
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
        windows = HabitatWindows<LiveEnvironment>(
            id: "test",
            for: habitat,
            whenAllWindowsHaveBeenClosed: {}
        )
    }
    
    func testWindowsAreSpawnedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, habitat.drawableChildren)
                
        habitat.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.habitat.drawableChildren)
            
            self.habitat.state.children.append(self.entity2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.windows.windows.count, self.habitat.drawableChildren)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.windows.windows.count, habitat.drawableChildren)
    }
    
    func testClosedWindowsAreRemovedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, habitat.drawableChildren)
        
        habitat.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.habitat.drawableChildren)
            
            self.entity1.kill()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.windows.windows.count, habitat.drawableChildren)
    }
}

private extension LiveEnvironment {
    
    var drawableChildren: Int {
        state.children.filter { $0.isDrawable }.count
    }
}
