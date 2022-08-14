//
// Pet Therapy.
//

import XCTest

@testable import Squanch

class RectContainsAnyOfTests: XCTestCase {
    
    func testTrueIfElementsAreOnRectStartEdge() {
        XCTAssertTrue(rect.contains(anyOf: [.ten]))
    }
    
    func testFalseIfElementsAreOnRectEndEdge() {
        XCTAssertFalse(rect.contains(anyOf: [.twenty]))
    }
    
    func testFalseIfNoElementsAreProvided() {
        XCTAssertFalse(rect.contains(anyOf: []))
    }
    
    func testFalseIfNoElementsAreContained() {
        XCTAssertFalse(rect.contains(anyOf: [.one, .five, .thirty]))
    }
    
    func testTrueIfAnyNumberOfElementsIsContained() {
        XCTAssertTrue(rect.contains(anyOf: [.one, .five, .fifteen]))
        XCTAssertTrue(rect.contains(anyOf: [.one, .fifteen, .sixteen]))
        XCTAssertTrue(rect.contains(anyOf: [.fifteen, .sixteen, .seventeen]))
    }
}

class RectContainsAllOfTests: XCTestCase {
    
    func testTrueIfElementsAreOnRectEdge() {
        XCTAssertTrue(rect.contains(allOf: [.ten]))
    }
    
    func testFalseIfElementsAreOnRectEdge() {
        XCTAssertFalse(rect.contains(allOf: [.twenty]))
    }
    
    func testTrueIfNoElementsAreProvided() {
        XCTAssertTrue(rect.contains(allOf: []))
    }
    
    func testFalseIfAnyNumberOfElementsIsNotContained() {
        XCTAssertFalse(rect.contains(allOf: [.one, .fifteen]))
        XCTAssertFalse(rect.contains(allOf: [.one, .five]))
    }
    
    func testTrueIfAllElementsAreContained() {
        XCTAssertTrue(rect.contains(allOf: [.fifteen]))
        XCTAssertTrue(rect.contains(allOf: [.fifteen, .sixteen]))
    }
}

private let rect = CGRect(x: 10, y: 10, width: 10, height: 10)

private extension CGPoint {

    static let one = CGPoint(x: 1, y: 1)
    static let five = CGPoint(x: 5, y: 5)
    static let ten = CGPoint(x: 10, y: 10)
    static let fifteen = CGPoint(x: 15, y: 15)
    static let sixteen = CGPoint(x: 16, y: 16)
    static let seventeen = CGPoint(x: 17, y: 18)
    static let twenty = CGPoint(x: 20, y: 20)
    static let thirty = CGPoint(x: 30, y: 30)
}
