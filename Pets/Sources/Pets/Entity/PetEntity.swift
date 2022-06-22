//
// Pet Therapy.
//

import AppState
import Biosphere
import Combine
import DesignSystem
import Squanch
import SwiftUI

open class PetEntity: Entity {
        
    public let species: Pet
    
    // MARK: - Init
    
    public init(
        of pet: Pet,
        size: CGSize? = nil,
        in habitatBounds: CGRect,
        installCapabilities: Bool = true
    ) {
        species = pet
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: habitatBounds, prefers: size),
            in: habitatBounds
        )
        speed = PetEntity.speed(for: species, size: frame.width)
        
        if installCapabilities {
            installAll(species.capabilities)
        }
    }
    
    // MARK: - Kill
    
    public override func kill(animated: Bool, onCompletion: @escaping () -> Void) {
        if !animated {
            super.kill()
        } else {
            set(state: .disappearing)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.kill(animated: false) {}
                onCompletion()
            }
        }
    }
    
    // MARK: - Animations
    
    open override func animationPath(for state: EntityState) -> String? {
        let path: String
        switch state {
        case .freeFall: path = species.dragPath
        case .drag: path = species.dragPath
        case .move: path = species.movementPath
        case .disappearing: return "smoke_bomb"
        case .animation(let animation): path = animation.id
        }
        return "\(species.id)_\(path)"
    }
}
