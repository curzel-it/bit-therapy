import DesktopKit
import Squanch

// MARK: - Behavior

public struct PetBehavior {
    
    let trigger: Trigger
    let possibleAnimations: [EntityAnimation]
    
    enum Trigger: Equatable {
        case random
        case on(spot: Hotspot)
    }
}

extension Pet {
    
    // MARK: - Animations by Spot
    
    public func action(whenTouching required: Hotspot) -> EntityAnimation? {
        behaviors
            .filter {
                if case .on(let spot) = $0.trigger { return spot == required }
                return false
            }
            .flatMap { $0.possibleAnimations }
            .random()
    }

    // MARK: - Random Animation
    
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
