import Combine
import Schwifty
import SwiftUI
import Yage

public class PetAnimationPathsProvider {    
    public init() {}
    
    public func frontAnimationPath(for pet: Pet) -> String {
        return "\(pet.id)_front"
    }
    
    public func animationPath(species: Pet, state: EntityState) -> String {
        let path: String
        switch state {
        case .freeFall: path = species.dragPath
        case .drag: path = species.dragPath
        case .move: path = species.movementPath
        case .action(let action, _): path = action.id
        }
        return "\(species.id)_\(path)"
    }
}
