import AppKit
import Rendering
import Foundation
import Swinject
import Yage

extension Rotating: SpriteRotation {}

extension Entity: RenderableEntity {
    public var isInteractable: Bool {
        !isEphemeral
    }
    
    public var spriteRotation: Rendering.SpriteRotation? {
        rotation
    }
    
    public var windowSize: CGSize {
        worldBounds.size
    }
    
    public func isBeingDragged() -> Bool {
        state == .drag
    }
    
    public func mouseDragged(currentDelta: CGSize) {
        mouseDrag?.mouseDragged(currentDelta: currentDelta)
    }
    
    public func mouseUp(totalDelta: CGSize) {
        mouseDrag?.mouseUp(totalDelta: totalDelta)
    }
    
    public func rightClicked(with event: NSEvent) {
        rightClick?.onRightClick(with: event)
    }
}

extension World: RenderableWorld {
    public var renderableChildren: [RenderableEntity] {
        children.filter { $0.isRenderable }
    }
}

private extension Entity {
    var isRenderable: Bool {
        sprite != nil        
    }
}
