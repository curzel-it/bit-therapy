import XCTest

@testable import Yage

// swiftlint:disable identifier_name
class PointsTests: XCTestCase {
    func testAngleBetweenPointsIsCorrect() {
        let o = CGPoint.zero
        XCTAssertEqual(o.angle(to: CGPoint(x: 0, y: 0)), 0, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 1, y: 1)), CGFloat.pi / 4, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 2, y: 2)), CGFloat.pi / 4, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 1, y: 0)), 0, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 0, y: 1)), CGFloat.pi / 2, accuracy: 0.0001)
    }

    func testPointOnEdgeOfRectIsDetectedProperly() {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        XCTAssertTrue(CGPoint(x: 0, y: 0).isOnEdge(of: rect))
        XCTAssertTrue(CGPoint(x: 0.5, y: 1).isOnEdge(of: rect))
        XCTAssertTrue(CGPoint(x: 0, y: 0.5).isOnEdge(of: rect))
        XCTAssertTrue(CGPoint(x: 0, y: 1).isOnEdge(of: rect))
        XCTAssertTrue(CGPoint(x: 1, y: 0).isOnEdge(of: rect))
        XCTAssertTrue(CGPoint(x: 1, y: 1).isOnEdge(of: rect))
        XCTAssertFalse(CGPoint(x: 0.1, y: 0.1).isOnEdge(of: rect))
        XCTAssertFalse(CGPoint(x: 0.5, y: 0.5).isOnEdge(of: rect))
    }

    func testAngleToOtherPointIsCorrect() {
        let o = CGPoint.zero
        XCTAssertEqual(o.angle(to: CGPoint(x: 0, y: 0)), 0.0 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 1, y: 0)), 0.0 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 1, y: 1)), 0.25 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 0, y: 1)), 0.5 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: -1, y: 1)), 0.75 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: -1, y: 0)), 1.0 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: -1, y: -1)), 1.25 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 0, y: -1)), 1.5 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 1, y: -1)), 1.75 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 0.9, y: 0.9)), 0.25 * .pi, accuracy: 0.0001)
        XCTAssertEqual(o.angle(to: CGPoint(x: 0.9, y: -0.9)), 1.75 * .pi, accuracy: 0.0001)
    }
}
