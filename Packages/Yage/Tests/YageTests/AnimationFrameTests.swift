import XCTest

@testable import Yage

class AnimationFrameTests: XCTestCase {
    
    var entity: Entity!
    
    override func setUp() {
        entity = Entity(
            id: "test",
            frame: CGRect(x: 5, y: 5, width: 5, height: 5),
            in: CGRect(x: 0, y: 0, width: 15, height: 15)
        )
    }
    
    func testAnimationFrameIsSameAsEntityFrameIfNoCustomSizeOrPositionAreSet() {
        let animation = EntityAnimation(
            id: "test",
            size: nil,
            position: .entityTopLeft,
            facingDirection: nil, chance: 1
        )
        XCTAssertEqual(entity.frame, animation.frame(for: entity))
    }
    
    func testAnimationFrameIsCorrectWhenLargerThanEntityFromBottomLeft() {
        let animation = EntityAnimation(
            id: "test",
            size: CGSize(width: 2, height: 2),
            position: .fromEntityBottomLeft,
            facingDirection: nil, chance: 1
        )
        let expected = CGRect(x: 5, y: 0, width: 10, height: 10)
        let animationFrame = animation.frame(for: entity)
        XCTAssertEqual(expected, animationFrame)
        XCTAssertEqual(expected.bottomLeft, animationFrame.bottomLeft)
        XCTAssertEqual(entity.frame.bottomLeft, animationFrame.bottomLeft)
    }
}
