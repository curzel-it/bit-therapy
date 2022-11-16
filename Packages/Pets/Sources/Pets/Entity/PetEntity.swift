import Combine
import Schwifty
import SwiftUI
import Yage

public protocol PetsSettings {
    var gravityEnabled: Bool { get }
    var petSize: CGFloat { get }
    var petsOnStage: CurrentValueSubject<[Pet], Never> { get }
    var speedMultiplier: CGFloat { get }
    var ufoAbductionSchedule: String { get }
    func remove(pet: Pet)
}

open class PetEntity: Entity {        
    public let species: Pet
    public let settings: PetsSettings
    
    public init(of species: Pet, in bounds: CGRect, settings: PetsSettings) {
        self.settings = settings
        self.species = species
        let id = PetEntity.id(for: species)
        let frame = PetEntity.initialFrame(in: bounds, size: settings.petSize)
        super.init(id: id, frame: frame, in: bounds)
        loadProperties()
    }
    
    func loadProperties() {
        fps = species.fps
        resetSpeed()
        species.capabilities().forEach { $0.install(on: self) }
        setupAutoRespawn()
        setInitialPosition()
        setInitialDirection()
        setGravity()
    }
    
    open override func set(state: EntityState) {
        super.set(state: state)
        if case .move = state { resetSpeed() }
    }
    
    public func resetSpeed() {
        speed = PetEntity.speed(
            for: species,
            size: frame.width,
            settings: settings.speedMultiplier
        )
    }
    
    open override func animationPath(for state: EntityState) -> String? {
        PetAnimationPathsProvider().animationPath(species: species, state: state)
    }
    
    private func setInitialPosition() {
        let randomX = CGFloat.random(in: 0.1..<0.75) * worldBounds.width
        let randomY: CGFloat
        
        if capability(for: WallCrawler.self) != nil {
            randomY = worldBounds.height - frame.height
        } else {
            randomY = CGFloat.random(in: 0.1..<0.5) * worldBounds.height
        }
        frame.origin = CGPoint(x: randomX, y: randomY)
    }
    
    private func setupAutoRespawn() {
        AutoRespawn.install(on: self)
    }
    
    private func setInitialDirection() {
        direction = .init(dx: 1, dy: 0)
    }
    
    public var supportsGravity: Bool {
        capability(for: WallCrawler.self) == nil
    }
    
    public func setGravity() {
        setGravity(enabled: settings.gravityEnabled && supportsGravity)
    }
}

