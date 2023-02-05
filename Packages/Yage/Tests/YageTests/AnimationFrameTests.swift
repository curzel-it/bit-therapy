import XCTest

@testable import Yage

class AnimationFrameTests: XCTestCase {
    var entity: Entity!

    override func setUp() {
        entity = Entity(
            species: .agent,
            id: "test",
            frame: CGRect(x: 5, y: 5, width: 5, height: 5),
            in: World(name: "", bounds: CGRect(x: 0, y: 0, width: 25, height: 25))
        )
    }

    func testAnimationFrameIsSameAsEntityFrameIfNoCustomSizeOrPositionAreSet() {
        let animation = EntityAnimation(
            id: "test",
            size: nil,
            position: .entityTopLeft,
            facingDirection: nil
        )
        XCTAssertEqual(entity.frame, animation.frame(for: entity))
    }

    func testAnimationFrameIsCorrectWhenLargerThanEntityFromBottomLeft() {
        let animation = EntityAnimation(
            id: "test",
            size: CGSize(width: 2, height: 2),
            position: .fromEntityBottomLeft,
            facingDirection: nil
        )
        let expected = CGRect(x: 5, y: 0, width: 10, height: 10)
        let animationFrame = animation.frame(for: entity)
        XCTAssertEqual(expected, animationFrame)
        XCTAssertEqual(expected.bottomLeft, animationFrame.bottomLeft)
        XCTAssertEqual(entity.frame.bottomLeft, animationFrame.bottomLeft)
    }
}
