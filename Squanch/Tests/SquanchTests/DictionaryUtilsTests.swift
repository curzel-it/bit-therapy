//
// Pet Therapy.
//

import XCTest

@testable import Squanch

class DictionaryUtilsTests: XCTestCase {
    
    func testMergingDictionariesReturnsAllKeysAndValues() {
        let first: [String: Int] = ["1": 1, "2": 2, "3": 3]
        let second: [String: Int] = ["4": 4, "5": 5, "6": 6]
        let merged = first.merging(with: second)
        
        let allKeys = merged.map { pair in pair.key }.sorted().joined(separator: "")
        XCTAssertEqual(allKeys, "123456")
        
        let allValues = merged.map { pair in pair.value }.sorted()
        XCTAssertEqual(allValues, [1, 2, 3, 4, 5, 6])
    }
    
    func testMergingDictionariesUpdatesValues() {
        let first: [String: Int] = ["1": 1, "2": 2, "3": 3]
        let second: [String: Int] = ["3": 4, "5": 5, "6": 6]
        let merged = first.merging(with: second)
        XCTAssertEqual(merged["3"], 4)
    }
}
