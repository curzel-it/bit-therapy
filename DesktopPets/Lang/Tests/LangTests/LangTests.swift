//
// Pet Therapy.
//

import XCTest

@testable import Lang

class LangTests: XCTestCase {
    
    func testLocalizedVersionOfNonTranslatedStringIsTheStringItself() {
        XCTAssertEqual("@non-translated".localized(), "@non-translated")
    }
}
