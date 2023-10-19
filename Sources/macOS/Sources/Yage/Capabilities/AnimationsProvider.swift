import Foundation

open class AnimationsProvider: Capability {
    open func randomAnimation() -> EntityAnimation? {
        subject?.species.animations.randomElement()
    }
}

extension Entity {
    var animationsProvider: AnimationsProvider? {
        capability(for: AnimationsProvider.self)
    }
}
