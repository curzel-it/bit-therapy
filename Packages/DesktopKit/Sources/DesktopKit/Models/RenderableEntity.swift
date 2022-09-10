import SwiftUI
import Yage

public typealias EntityState = Yage.EntityState

open class RenderableEntity: Entity {
    @Published public var sprite: NSImage?
    @Published public var backgroundColor: Color = .clear
    
    open func animationPath(for state: EntityState) -> String? { nil }
    
    open override func kill() {
        super.kill()
        sprite = nil
    }
}
