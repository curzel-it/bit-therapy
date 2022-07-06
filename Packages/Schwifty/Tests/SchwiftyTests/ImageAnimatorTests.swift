//
// Pet Therapy.
//

import XCTest

@testable import Schwifty

class ImageAnimatorTests: XCTestCase {
    
    func testLoopDuracyIsProperlyCalculated() {
        let frames = (0..<10).map { _ in NSImage() }
        let animation = ImageAnimator(basePath: "", frames: frames)
        XCTAssertEqual(animation.loopDuracy, 1)
    }
    
    func testFramesUpdateWhenNeeded() {
        let frames = (0..<10).map { _ in NSImage() }
        let animation = ImageAnimator(basePath: "", frames: frames)
        XCTAssertEqual(animation.currentFrameIndex, 0)
        _ = animation.nextFrame(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 0)
        _ = animation.nextFrame(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 1)
        _ = animation.nextFrame(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 1)
        _ = animation.nextFrame(after: 0.05)
        XCTAssertEqual(animation.currentFrameIndex, 2)
        _ = animation.nextFrame(after: 0.75)
        XCTAssertEqual(animation.currentFrameIndex, 9)
        _ = animation.nextFrame(after: 0.08)
        XCTAssertEqual(animation.currentFrameIndex, 0)
    }
}
