import Foundation

open class AnimationsProvider: Capability {
    open func action(whenTouching required: Hotspot) -> EntityAnimation? {
        return nil
    }
    
    open func randomAnimation() -> EntityAnimation? {
        return nil
    }
}

extension Entity {
    var animationsProvider: AnimationsProvider? { capability(for: AnimationsProvider.self) }
}
