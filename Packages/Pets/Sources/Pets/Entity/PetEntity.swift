import Combine
import Squanch
import SwiftUI
import Yage

public protocol PetsSettings {
    var gravityEnabled: Bool { get }
    var petSize: CGFloat { get }
    var speedMultiplier: CGFloat { get }
}

open class PetEntity: Entity {        
    public let species: Pet
    public let settings: PetsSettings
    
    public init(
        of pet: Pet,
        size: CGFloat? = nil,
        in worldBounds: CGRect,
        settings: PetsSettings
    ) {
        self.settings = settings
        self.species = pet
        
        super.init(
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: worldBounds, size: size ?? settings.petSize),
            in: worldBounds
        )
        resetSpeed()
        species.capabilities().forEach { install($0) }
    }
    
    open override func set(state: EntityState) {
        super.set(state: state)
        if case .move = state { resetSpeed() }
    }
    
    public func resetSpeed() {
        speed = PetEntity.speed(for: species, size: frame.width, settings: settings.speedMultiplier)
    }
    
    open override func animationPath(for state: EntityState) -> String? {
        PetAnimationPathsProvider().animationPath(species: species, state: state)
    }
}
