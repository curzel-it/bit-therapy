//
// Pet Therapy.
//

import Biosphere
import Combine
import Squanch
import SwiftUI

public class PetAnimationPathsProvider {
    
    public init() {}
    
    public func frontAnimationPath(for pet: Pet) -> String {
        animationPath(species: pet, state: .animation(animation: .front, loops: 1))
    }
    
    public func animationPath(species: Pet, state: EntityState) -> String {
        let path: String
        switch state {
        case .freeFall: path = species.dragPath
        case .drag: path = species.dragPath
        case .move: path = species.movementPath
        case .disappearing: return "smoke_bomb"
        case .animation(let animation, _): path = animation.id
        }
        return "\(species.id)_\(path)"
    }
}
