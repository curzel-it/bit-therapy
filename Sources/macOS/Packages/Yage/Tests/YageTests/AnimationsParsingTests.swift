import SwiftUI
import XCTest

@testable import Yage

class AnimationsParsing: XCTestCase {
    func testSingleAnimationCanBeParsed() {
        let json = """
{
  "id": "front",
  "position": "fromEntityBottomLeft",
  "requiredLoops": 5
}
"""
        let animation = try? JSONDecoder().decode(EntityAnimation.self, from: json.data(using: .utf8)!)
        XCTAssertNotNil(animation)
        XCTAssertEqual(animation?.id, "front")
        XCTAssertEqual(animation?.position, .fromEntityBottomLeft)
        XCTAssertEqual(animation?.requiredLoops, 5)
    }
    
    func testSingleAnimationInLegacyFormatCanBeParsedWithFallback() {
        let json = """
{
  "id": "front",
  "position": { "fromEntityBottomRight": {} },
  "requiredLoops": 5
}
"""
        let animation = try? JSONDecoder().decode(EntityAnimation.self, from: json.data(using: .utf8)!)
        XCTAssertNotNil(animation)
        XCTAssertEqual(animation?.id, "front")
        XCTAssertEqual(animation?.position, .fromEntityBottomLeft)
        XCTAssertEqual(animation?.requiredLoops, 5)
    }
}
