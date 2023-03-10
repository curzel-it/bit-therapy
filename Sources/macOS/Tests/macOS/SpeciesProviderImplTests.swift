import AppKit
import XCTest

@testable import Desktop_Pets

final class SpeciesProviderImplTests: XCTestCase {
    func testCanParseAllSpecies() {
        let provider = SpeciesProviderImpl()
        let expectedCount = provider.allJsonUrls.count
        XCTAssertEqual(expectedCount, provider.all.value.count)
    }
}
