import Foundation
import NotAGif
import Schwifty
import Yage

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
    func dragged(currentDelta: CGSize)
    func dragEnded(totalDelta: CGSize)
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
    
    func dragged(currentDelta: CGSize) {
        drag?.dragged(currentDelta: currentDelta)
    }
    
    func dragEnded(totalDelta: CGSize) {
        drag?.dragEnded(totalDelta: totalDelta)
    }
    
    func rightClicked(from window: SomeWindow?, at point: CGPoint) {
        rightClick?.onRightClick(from: window, at: point)
    }
}

extension World {
    var renderableChildren: [RenderableEntity] {
        children.filter { $0.isRenderable }
    }
}

private extension Entity {
    var isRenderable: Bool {
        sprite != nil
    }
}
