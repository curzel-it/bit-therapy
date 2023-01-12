import Combine
import Schwifty
import XCTest

@testable import MacWidgets

class WidgetWindowTests: XCTestCase {
    var widget: TestWidget!
    var coordinator: WidgetsCoordinator!

    override func setUp() {
        coordinator?.kill()
        coordinator = WidgetsCoordinator()
        widget = TestWidget(id: "test")
    }
    
    func testAddingWidgetToCoordinatorCreatesWindow() {
        coordinator.add(widget: widget)
        
        let expectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(coordinator.windows.count, 1)
        XCTAssertEqual(coordinator.widgets.value.count, 1)
    }
    
    func testCannotAddMultipleTimeTheSameWidget() {
        coordinator.add(widget: widget)
        coordinator.add(widget: widget)
        coordinator.add(widget: widget)
        
        let expectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(coordinator.windows.count, 1)
        XCTAssertEqual(coordinator.widgets.value.count, 1)
    }
    
    func testKillingWidgetClosesWindow() {
        coordinator.add(widget: widget)
        DispatchQueue.main.async {
            self.widget.isAlive.send(false)
        }
        
        let expectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(coordinator.windows.count, 0)
        XCTAssertEqual(coordinator.widgets.value.count, 0)
    }
    
    func testUpdatingWidgetFrameUpdatesWindowFrame() {
        coordinator.add(widget: widget)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.widget.frame.send(CGRect(x: 500, y: 500, width: 100, height: 100))
        }
        
        let expectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
        let windowFrame = coordinator.windows.values.first?.frame
        XCTAssertEqual(widget.frame.value, windowFrame)
    }
}
