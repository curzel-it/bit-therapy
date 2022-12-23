import Foundation

open class AnimationsProvider: Capability {
    open func randomAnimation() -> EntityAnimation? {
        subject?.species.behaviors
            .filter { $0.trigger == .random }
            .flatMap { $0.possibleAnimations }
            .random()
    }
}

extension Entity {
    var animationsProvider: AnimationsProvider? { capability(for: AnimationsProvider.self) }
}

extension Array where Element == EntityAnimation {
    func random() -> EntityAnimation? {
        randomElement(distribution: probabilities())
    }

    private func probabilities() -> [Double] {
        map { $0.chance }
    }
}
