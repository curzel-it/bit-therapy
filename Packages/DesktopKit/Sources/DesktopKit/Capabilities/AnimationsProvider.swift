import Foundation
import Yage

open class AnimationsProvider: DKCapability {
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
