//
// Pet Therapy.
//

import XCTest

@testable import OnScreen

final class OnScreenEventsTests: XCTestCase {
    
    var viewModel: ViewModel!
    
    override func setUp() {
        viewModel = ViewModel()
    }
    
    func testUfoLandingIsCorrectlyScheduled() {
        let event = viewModel.scheduleUfoAbduction()
        if case .timeOfDay(let hour, let minute) = event.schedulingRule {
            XCTAssertEqual(hour, 22)
            XCTAssertEqual(minute, 30)
        } else {
            XCTAssert(false)
        }
    }
}
