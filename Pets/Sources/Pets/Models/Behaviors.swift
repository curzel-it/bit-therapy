//
// Pet Therapy.
//

import Biosphere
import Squanch

// MARK: - Behavior

public struct PetBehavior {
    
    let trigger: PetBehavior.Trigger
    let possibleAnimations: [EntityAnimation]
    
    public enum Trigger {
        case onAnyCorner
        case onLateralBounds
        case on(spot: Hotspot)
    }
}

// MARK: - Behavior Application

extension PetBehavior {
    
    public func applies(whenTouching spot: Hotspot) -> Bool {
        switch trigger {
        case .on(let required): return required == spot
        case .onLateralBounds: return spot.isLateralBound
        case .onAnyCorner: return spot.isCorner || spot.isAnchor
        }
    }
}

extension Pet {
    
    public func behaviors(whenTouching spot: Hotspot) -> [PetBehavior] {
        behaviors.filter { $0.applies(whenTouching: spot) }
    }
    
    public func action(whenTouching spot: Hotspot) -> EntityAnimation? {
        let possibleAnimations = behaviors(whenTouching: spot)
            .flatMap { $0.possibleAnimations }
        let probabilities = possibleAnimations.map { $0.chance }
        return possibleAnimations.randomElement(distribution: probabilities)
    }
}
