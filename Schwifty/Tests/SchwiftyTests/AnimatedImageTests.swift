//
// Pet Therapy.
//

import XCTest

@testable import Schwifty

class AnimatedImageTests: XCTestCase {
    
    func testLoopDuracyIsProperlyCalculated() {
        let frames = (0..<10).map { _ in NSImage() }
        let animation = AnimatedImage("", frameTime: 0.1, frames: frames)
        XCTAssertEqual(animation.loopDuracy, 1)
    }
    
    func testFramesUpdateWhenNeeded() {
        let frames = (0..<10).map { _ in NSImage() }
        let animation = AnimatedImage("", frameTime: 0.1, frames: frames)
        XCTAssertEqual(animation.currentFrameIndex, 0)
        animation.update(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 0)
        animation.update(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 1)
        animation.update(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 1)
        animation.update(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 2)
        animation.update(after: 0.75)
        XCTAssertEqual(animation.currentFrameIndex, 9)
        animation.update(after: 0.08)
        XCTAssertEqual(animation.currentFrameIndex, 0)
    }
}
