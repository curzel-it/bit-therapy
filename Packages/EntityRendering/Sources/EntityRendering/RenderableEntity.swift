import AppKit
import Foundation

public protocol RenderableEntity { 
    var frame: CGRect { get }
    var isAlive: Bool { get }
    var sprite: String? { get }
    var spriteRotation: SpriteRotation? { get }
    var windowSize: CGSize { get }
    var zIndex: Int { get }
    
    func isBeingDragged() -> Bool
    func mouseDragged(currentDelta: CGSize)
    func mouseUp(totalDelta: CGSize) -> CGPoint?
    func rightClicked(with: NSEvent)
}

public protocol SpriteRotation {
    var isFlippedVertically: Bool { get }
    var isFlippedHorizontally: Bool { get }
    var zAngle: CGFloat { get }
}

extension RenderableEntity {
    func spriteHash() -> Int {
        var hasher = Hasher()
        hasher.combine(sprite)
        hasher.combine(frame.size.width)
        hasher.combine(frame.size.height)
        hasher.combine(spriteRotation?.isFlippedHorizontally ?? false)
        hasher.combine(spriteRotation?.isFlippedVertically ?? false)
        hasher.combine(spriteRotation?.zAngle ?? 0)
        return hasher.finalize()
    }
}
