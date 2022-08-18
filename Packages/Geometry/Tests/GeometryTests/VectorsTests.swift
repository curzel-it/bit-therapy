//
// Pet Therapy.
//

import XCTest

@testable import Geometry

class VectorTests: XCTestCase {
    
    func testCorrectMagnitudeIsCalculated() {
        XCTAssertEqual(CGVector(dx: 0, dy: 1).magnitude(), 1, accuracy: 0.000001)
        XCTAssertEqual(CGVector(dx: 1, dy: 0).magnitude(), 1, accuracy: 0.000001)
        XCTAssertEqual(CGVector(dx: 1, dy: 1).magnitude(), sqrt(2), accuracy: 0.000001)
        XCTAssertEqual(CGVector(dx: 1, dy: 2).magnitude(), sqrt(5), accuracy: 0.000001)
        XCTAssertEqual(CGVector(dx: 2, dy: 1).magnitude(), sqrt(5), accuracy: 0.000001)
        XCTAssertEqual(CGVector(dx: 2, dy: 2).magnitude(), sqrt(8), accuracy: 0.000001)
    }
    
    func testSettingMagnitudeIsCorrect() {
        XCTAssertEqual(
            CGVector(dx: 0, dy: 1).with(magnitude: 0),
            CGVector(dx: 0, dy: 0)
        )
        XCTAssertEqual(
            CGVector(dx: 0, dy: 1).with(magnitude: 2),
            CGVector(dx: 0, dy: 2)
        )
        XCTAssertEqual(
            CGVector(dx: 1, dy: 1).with(magnitude: sqrt(2)),
            CGVector(dx: 1, dy: 1)
        )
        XCTAssertEqual(
            CGVector(dx: 1, dy: 1).with(magnitude: sqrt(32)),
            CGVector(dx: 4, dy: 4)
        )
    }
    
    func testCorrectUnitVectorIsCalculated() {
        XCTAssertEqual(
            CGVector(dx: 0, dy: 1).with(magnitude: 0).unit(),
            CGVector(dx: 0, dy: 0)
        )
        XCTAssertEqual(
            CGVector(dx: 0, dy: 1).with(magnitude: 2).unit(),
            CGVector(dx: 0, dy: 1)
        )
        XCTAssertEqual(
            CGVector(dx: 1, dy: 1).unit(),
            CGVector(dx: 1/sqrt(2), dy: 1/sqrt(2))
        )
        XCTAssertEqual(
            CGVector(dx: 1, dy: 1).with(magnitude: sqrt(32)).unit(),
            CGVector(dx: 1/sqrt(2), dy: 1/sqrt(2))
        )
    }
    
    func testUnitVectorBetweenPointsIsCorrect() {
        (0..<20)
            .map { CGFloat.pi * CGFloat($0) / 10 }
            .forEach { angle in
                let expected = CGVector(radians: angle).unit()
                let somePointAlongVector = CGPoint(
                    radians: angle,
                    radius: CGFloat.random(in: 0..<100)
                )
                let testVector = CGVector.unit(
                    from: .zero,
                    to: somePointAlongVector
                )
                XCTAssertEqual(expected.dx, testVector.dx, accuracy: 0.0001)
                XCTAssertEqual(expected.dy, testVector.dy, accuracy: 0.0001)
            }
    }
}
