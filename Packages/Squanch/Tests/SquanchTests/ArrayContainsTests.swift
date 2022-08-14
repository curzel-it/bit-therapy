//
// Pet Therapy.
//

import XCTest

@testable import Squanch

class ArrayContainsAnyOfTests: XCTestCase {
    
    func testFalseIfNoElementsAreProvided() {
        XCTAssertFalse([1, 2, 3, 4].contains(anyOf: []))
    }
    
    func testFalseIfNoElementsAreContained() {
        XCTAssertFalse([1, 2, 3, 4].contains(anyOf: [5, 6, 7]))
    }
    
    func testTrueIfAnyNumberOfElementsIsContained() {
        XCTAssertTrue([1, 2, 3, 4].contains(anyOf: [4, 5, 6, 7]))
        XCTAssertTrue([1, 2, 3, 4].contains(anyOf: [3, 4, 5, 6, 7]))
        XCTAssertTrue([1, 2, 3, 4].contains(anyOf: [1]))
    }
}

class ArrayContainsAllOfTests: XCTestCase {
    
    func testTrueIfNoElementsAreProvided() {
        XCTAssertTrue([1, 2, 3, 4].contains(allOf: []))
    }
    
    func testFalseIfAnyNumberOfElementsIsNotContained() {
        XCTAssertFalse([1, 2, 3, 4].contains(allOf: [4, 5, 6, 7]))
        XCTAssertFalse([1, 2, 3, 4].contains(allOf: [3, 4, 5, 6, 7]))
    }
    
    func testTrueIfAllElementsAreContained() {
        XCTAssertTrue([1, 2, 3, 4].contains(allOf: [1]))
        XCTAssertTrue([1, 2, 3, 4].contains(allOf: [1, 2]))
    }
}
 
