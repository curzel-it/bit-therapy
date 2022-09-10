import XCTest

@testable import DesktopKit

class HabitatWindowsTests: XCTestCase {
    
    var habitat: LiveHabitat!
    var entity1: RenderableEntity!
    var entity2: RenderableEntity!
    var windows: HabitatWindows!
    
    override func setUp() {
        let baseSize = CGRect(origin: .zero, size: .init(square: 100))
        
        entity1?.kill()
        entity2?.kill()
        habitat?.kill()
        windows?.kill()
        
        habitat = LiveHabitat(id: "HabitatWindowsTests", bounds: CGRect(size: .init(square: 1000)))
        entity1 = RenderableEntity(id: "test1", frame: baseSize, in: habitat.state.bounds)
        entity2 = RenderableEntity(id: "test2", frame: baseSize, in: habitat.state.bounds)
        windows = HabitatWindows(for: habitat)
    }
    
    func testWindowsAreSpawnedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, habitat.renderableChildren)
                
        habitat.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.habitat.renderableChildren)
            
            self.habitat.state.children.append(self.entity2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.windows.windows.count, self.habitat.renderableChildren)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.windows.windows.count, habitat.renderableChildren)
    }
    
    func testClosedWindowsAreRemovedAutomatically() {
        let expectation = expectation(description: "")
        XCTAssertEqual(windows.windows.count, habitat.renderableChildren)
        
        habitat.state.children.append(entity1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.windows.windows.count, self.habitat.renderableChildren)
            
            self.entity1.kill()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.windows.windows.count, habitat.renderableChildren)
    }
}

private extension LiveHabitat {
    
    var renderableChildren: Int {
        state.children
            .compactMap { $0 as? RenderableEntity }
            .filter { $0.isAlive }
            .count
    }
}
