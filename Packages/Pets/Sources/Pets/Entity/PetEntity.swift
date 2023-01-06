import Combine
import Schwifty
import SwiftUI
import Yage

public protocol PetsSettings {
    var gravityEnabled: Bool { get }
    var petSize: CGFloat { get }
    var speciesOnStage: CurrentValueSubject<[Species], Never> { get }
    var speedMultiplier: CGFloat { get }
    var ufoAbductionSchedule: String { get }
    func remove(species: Species)
}

open class PetEntity: Entity {
    public static var assetsProvider: AssetsProvider?
    public let settings: PetsSettings

    public init(of species: Species, in world: World, settings: PetsSettings) {
        self.settings = settings
        super.init(
            species: species,
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: world.bounds, size: settings.petSize),
            in: world
        )
        loadProperties()
    }

    func loadProperties() {
        resetSpeed()
        setInitialPosition()
        setInitialDirection()
        setGravity()
    }

    override open func set(state: EntityState) {
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

    private func setInitialPosition() {
        let randomX = CGFloat.random(in: 0.1 ..< 0.75) * worldBounds.width 
        let randomY: CGFloat

        if capability(for: WallCrawler.self) != nil {
            randomY = worldBounds.height - frame.height
        } else {
            randomY = CGFloat.random(in: 0.1 ..< 0.5) * worldBounds.height
        }
        frame.origin = CGPoint(x: randomX, y: randomY)
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
