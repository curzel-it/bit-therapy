//
// Pet Therapy.
//

import XCTest

@testable import AppState

final class AppStateTests: XCTestCase {
    
    func testDefaultConfigurationIsCorrect() {
        let defaults = AppState()
        XCTAssertEqual(defaults.selectedPage, .home)
    }
}
