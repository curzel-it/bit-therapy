import AppKit
import Combine
import XCTest

@testable import BitTherapy

final class SpeciesProviderImplTests: XCTestCase {
    private var disposables = Set<AnyCancellable>()

    override func tearDown() {
        disposables = Set<AnyCancellable>()
    }

    func testCanParseAllSpecies() async {
        let provider = SpeciesProviderImpl()
        let expectedCount = provider.allJsonUrls.count
        let actualCount = await withCheckedContinuation { continuation in
            provider.all()
                .receive(on: DispatchQueue.main)
                .sink { continuation.resume(returning: $0.count) }
                .store(in: &disposables)
        }
        XCTAssertEqual(expectedCount, actualCount)
    }
}
