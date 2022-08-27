//
// Pet Therapy.
//

import DesktopKit
import Combine
import Squanch
import SwiftUI

open class PetEntity: Entity {
        
    public let species: Pet
    
    // MARK: - Init
    
    public init(
        of pet: Pet,
        size: CGFloat,
        in habitatBounds: CGRect,
        installCapabilities: Bool = true
    ) {
        species = pet
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: habitatBounds, size: size),
            in: habitatBounds
        )
        speed = PetEntity.speed(for: species, size: frame.width)
        
        if installCapabilities {
            installAll(species.capabilities)
        }
    }
    
    // MARK: - Kill
    
    open override func kill(animated: Bool, onCompletion: @escaping () -> Void = {}) {
        if !animated {
            super.kill(animated: false)
        } else {
            set(state: .disappearing)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.kill(animated: false)
                onCompletion()
            }
        }
    }
    
    // MARK: - Animations
    
    open override func animationPath(for state: EntityState) -> String? {
        PetAnimationPathsProvider().animationPath(species: species, state: state)
    }
}
