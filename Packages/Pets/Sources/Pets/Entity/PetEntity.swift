import DesktopKit
import Combine
import Squanch
import SwiftUI

open class PetEntity: RenderableEntity {        
    public let species: Pet
    
    public init(
        of pet: Pet,
        size: CGFloat,
        in worldBounds: CGRect
    ) {
        species = pet
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: worldBounds, size: size),
            in: worldBounds
        )
        speed = PetEntity.speed(for: species, size: frame.width)
        species.capabilities().forEach { install($0) }
    }
    
    open override func animationPath(for state: EntityState) -> String? {
        PetAnimationPathsProvider().animationPath(species: species, state: state)
    }
}
