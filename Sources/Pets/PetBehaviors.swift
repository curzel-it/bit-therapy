//
// Pet Therapy.
//

import Physics
import Squanch

// MARK: - Behavior

struct PetBehavior {
    
    let trigger: PetBehavior.Trigger
    let actions: [PetAction]
    
    enum Trigger {
        case onAnyCorner
        case onLateralBounds
        case on(spot: Hotspot)
    }
}

// MARK: - Behavior Application

extension PetBehavior {
    
    func applies(whenTouching spot: Hotspot) -> Bool {
        switch trigger {
        case .on(let required): return required == spot
        case .onLateralBounds: return spot.isLateralBound
        case .onAnyCorner: return spot.isCorner || spot.isAnchor
        }
    }
}

extension Pet {
    
    func behaviors(whenTouching spot: Hotspot) -> [PetBehavior] {
        behaviors.filter { $0.applies(whenTouching: spot) }
    }
    
    func action(whenTouching spot: Hotspot) -> PetAction? {
        let actions = behaviors(whenTouching: spot).flatMap { $0.actions }
        let probabilities = actions.map { $0.chance }
        return actions.randomElement(distribution: probabilities)
    }
}
