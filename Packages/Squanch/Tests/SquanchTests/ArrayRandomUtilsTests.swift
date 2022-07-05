//
// Pet Therapy.
//

import XCTest

@testable import Squanch

class ArrayRandomUtilsTests: XCTestCase {
    
    func testReturnsNilWhenArrayIsEmpty() {
        XCTAssertNil([].randomElement(distribution: [1, 2]))
    }
    
    func testReturnsNilWhenDistributionIsEmpty() {
        XCTAssertNil([1, 2].randomElement(distribution: []))
    }
    
    func testReturnsNilWhenDistributionAndArrayLengthMismatch() {
        XCTAssertNil([1, 2].randomElement(distribution: [1, 2, 3]))
    }
    
    func testReturnsNilWhenDistributionIsZero() {
        XCTAssertNil([1, 2].randomElement(distribution: [0, 0]))
    }
    
    func testReturnsFirstElementWhenArrayCountIsOneAndProbabilityIsNotZero() {
        XCTAssertNotNil([1].randomElement(distribution: [1]))
    }
    
    func testReturnsNilWhenArrayCountIsOneAndProbabilityIsZero() {
        XCTAssertNil([1].randomElement(distribution: [0]))
    }
    
    func testReturnsNilWhenProbabilitiesAreZeroForAllElements() {
        XCTAssertNil([1, 2].randomElement(distribution: [0, 0]))
    }
}
 
