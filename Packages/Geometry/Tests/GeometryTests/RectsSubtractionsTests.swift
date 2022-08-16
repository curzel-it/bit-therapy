//
// Pet Therapy.
//

import XCTest

@testable import Geometry

class SubtractionsTests: XCTestCase {
    
    func testSplitHorizontallyFiltersInvalidValues() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        XCTAssertEqual(rect.split(x: 0).count, 1)
        XCTAssertEqual(rect.split(x: 15).count, 1)
    }
    
    func testSplitVerticallyFiltersInvalidValues() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        XCTAssertEqual(rect.split(x: 0).count, 1)
        XCTAssertEqual(rect.split(x: 15).count, 1)
    }
    
    func testSplitHorizontallyIsCorrect() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        let parts = rect.split(x: 8)
        XCTAssertEqual(parts.count, 2)
        XCTAssertEqual(parts[0].width, 3)
        XCTAssertEqual(parts[0].height, 5)
        XCTAssertEqual(parts[1].width, 2)
        XCTAssertEqual(parts[1].height, 5)
        XCTAssertEqual(parts[0].union(parts[1]), rect)
    }
    
    func testSplitVerticallyIsCorrect() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        let parts = rect.split(y: 8)
        XCTAssertEqual(parts.count, 2)
        XCTAssertEqual(parts[0].width, 5)
        XCTAssertEqual(parts[0].height, 3)
        XCTAssertEqual(parts[1].width, 5)
        XCTAssertEqual(parts[1].height, 2)
        XCTAssertEqual(parts[0].union(parts[1]), rect)
    }
    
    func testSubtractingNonOverlappingRectReturnsOriginalRect() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        let other = CGRect(x: 0, y: 5, width: 2, height: 5)
        let parts = rect.parts(bySubtracting: other)
        XCTAssertEqual(parts.count, 1)
        XCTAssertEqual(parts[0], rect)
    }
    
    func testSubtractingRectOfWidthZeroHeightInfiniteIsSameAsSplittingHorizontally() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        let other = CGRect(x: 8, y: 0, width: 2, height: 10)
        XCTAssertEqual(rect.parts(bySubtracting: other), rect.split(x: 8))
    }
    
    func testSubtractingRectOfHeightZeroWidthInfiniteIsSameAsSplittingVertically() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        let other = CGRect(x: 0, y: 8, width: 10, height: 2)
        XCTAssertEqual(rect.parts(bySubtracting: other), rect.split(y: 8))
    }
    
    func testSubtractingRectLargerThanOriginalReturnsOriginalRect() {
        let rect = CGRect(x: 5, y: 5, width: 5, height: 5)
        let other = CGRect(x: 0, y: 0, width: 15, height: 15)
        XCTAssertEqual(rect.parts(bySubtracting: other), [rect])
    }
    
    func testSubtractingSmallSquareWithinRectReturnsExactlyEightConsistentParts() {
        let rect = CGRect(x: 0, y: 0, width: 5, height: 5)
        let other = CGRect(x: 2, y: 2, width: 1, height: 1)
        let parts = rect.parts(bySubtracting: other)
        
        let expectedParts: [CGRect] = [
            CGRect(x: 0, y: 0, width: 2, height: 2),
            CGRect(x: 0, y: 2, width: 2, height: 1),
            CGRect(x: 0, y: 3, width: 2, height: 2),
            
            CGRect(x: 2, y: 0, width: 1, height: 2),
            CGRect(x: 2, y: 3, width: 1, height: 2),
            
            CGRect(x: 3, y: 0, width: 2, height: 2),
            CGRect(x: 3, y: 2, width: 2, height: 1),
            CGRect(x: 3, y: 3, width: 2, height: 2)
        ]
        XCTAssertEqual(parts, expectedParts)
    }
}
