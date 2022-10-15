import Squanch
import Yage

// MARK: - Behavior

public struct PetBehavior {
    
    let trigger: Trigger
    let possibleAnimations: [EntityAnimation]
    
    enum Trigger: Equatable {
        case random
        case on(spot: Hotspot)
    }
}

// MARK: - Get Animations

extension Pet {
    
    public func action(whenTouching required: Hotspot) -> EntityAnimation? {
        behaviors
            .filter {
                if case .on(let spot) = $0.trigger { return spot == required }
                return false
            }
            .flatMap { $0.possibleAnimations }
            .random()
    }
    
    public func randomAnimation() -> EntityAnimation? {
        behaviors
            .filter { $0.trigger == .random }
            .flatMap { $0.possibleAnimations }
            .random()
    }
}

// MARK: - Random Animations

extension Array where Element == EntityAnimation {
    
    func random() -> EntityAnimation? {
        randomElement(distribution: probabilities())
    }
    
    private func probabilities() -> [Double] {
        map { $0.chance }
    }
}
