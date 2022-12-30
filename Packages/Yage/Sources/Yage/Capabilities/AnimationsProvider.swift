import Foundation

open class AnimationsProvider: Capability {
    open func randomAnimation() -> EntityAnimation? {
        subject?.species.behaviors
            .filter { $0.trigger == .random }
            .flatMap { $0.possibleAnimations }
            .randomElement()
    }
}

extension Entity {
    var animationsProvider: AnimationsProvider? {
        capability(for: AnimationsProvider.self)
    }
}
