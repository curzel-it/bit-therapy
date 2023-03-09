import Foundation
import NotAGif
import Schwifty
import Yage

protocol RenderableWorld {
    var bounds: CGRect { get }
    var renderableChildren: [RenderableEntity] { get }
    var name: String { get }
    
    func kill()
    func set(bounds newBounds: CGRect)
    func update(after: TimeInterval)
}

protocol RenderableEntity {
    var frame: CGRect { get }
    var id: String { get }
    var isAlive: Bool { get }
    var isInteractable: Bool { get }
    var sprite: String? { get }
    var spriteRotation: SpriteRotation? { get }
    var windowSize: CGSize { get }
    var zIndex: Int { get }
    
    func isBeingDragged() -> Bool
    func mouseDragged(currentDelta: CGSize)
    func mouseUp(totalDelta: CGSize)
    func rightClicked(from window: SomeWindow?, at point: CGPoint)
}

protocol SpriteRotation {
    var isFlippedVertically: Bool { get }
    var isFlippedHorizontally: Bool { get }
    var zAngle: CGFloat { get }
}

protocol AssetsProvider {
    func image(sprite: String?) -> ImageFrame?
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

extension Rotating: SpriteRotation {}

extension Entity: RenderableEntity {
    var isInteractable: Bool {
        !isEphemeral
    }
    
    var spriteRotation: SpriteRotation? {
        rotation
    }
    
    var windowSize: CGSize {
        worldBounds.size
    }
    
    func isBeingDragged() -> Bool {
        state == .drag
    }
    
    func mouseDragged(currentDelta: CGSize) {
        mouseDrag?.mouseDragged(currentDelta: currentDelta)
    }
    
    func mouseUp(totalDelta: CGSize) {
        mouseDrag?.mouseUp(totalDelta: totalDelta)
    }
    
    func rightClicked(from window: SomeWindow?, at point: CGPoint) {
        rightClick?.onRightClick(from: window, at: point)
    }
}

extension World: RenderableWorld {
    var renderableChildren: [RenderableEntity] {
        children.filter { $0.isRenderable }
    }
}

private extension Entity {
    var isRenderable: Bool {
        sprite != nil
    }
}
