import Combine
import Schwifty
import SwiftUI
import Yage

class PetEntity: Entity {
    @Inject private var settings: AppConfig
    
    private var disposables = Set<AnyCancellable>()

    public init(of species: Species, in world: World) {
        super.init(
            species: species,
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(for: species),
            in: world
        )
        resetSpeed()
        setInitialPosition()
        setInitialDirection()
        bindGravity()
        bindBounceOffPets()
    }
    
    private func bindBounceOffPets() {
        settings.$bounceOffPetsEnabled
            .sink { [weak self] in self?.setBounceOffPets(enabled: $0) }
            .store(in: &disposables)
    }
    
    private func setBounceOffPets(enabled: Bool) {
        guard let bounce = capability(for: BounceOnLateralCollisions.self) else { return }
        if enabled {
            bounce.customCollisionsFilter = { _ in true }
        } else {
            bounce.customCollisionsFilter = nil
        }
    }
    
    private func bindGravity() {
        settings.$gravityEnabled
            .sink { [weak self] in self?.setGravity(enabled: $0) }
            .store(in: &disposables)
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
    
    func setInitialPosition() {
        let randomX = worldBounds.width * .random(in: 0.05...0.95)
        let randomY: CGFloat

        if capability(for: WallCrawler.self) != nil {
            randomY = worldBounds.height - frame.height
        } else {
            randomY = 60 
        }
        frame.origin = CGPoint(x: randomX, y: randomY)
    }

    func setInitialDirection() {
        direction = .init(dx: 1, dy: 0)
    }
    
    override open func kill() {
        disposables.removeAll()
        super.kill()
    }
}

// MARK: - Incremental Id

extension PetEntity {
    static func id(for species: Species) -> String {
        nextNumber += 1
        return "\(species.id)-\(nextNumber)"
    }

    private static var nextNumber = 0
}

// MARK: - Speed

extension PetEntity {
    internal static let baseSpeed: CGFloat = 30

    static func initialFrame(for species: Species) -> CGRect {
        @Inject var appConfig: AppConfig
        return CGRect(square: appConfig.petSize * species.scale)
    }
    
    static func speed(for species: Species, size: CGFloat, settings: CGFloat) -> CGFloat {
        species.speed * speedMultiplier(for: size) * settings
    }

    static func speedMultiplier(for size: CGFloat) -> CGFloat {
        let sizeRatio = size / PetSize.defaultSize
        return baseSpeed * sizeRatio
    }
}

// MARK: - Pet Size

public struct PetSize {
    public static let defaultSize: CGFloat = DeviceRequirement.iPhone.isSatisfied ? 50 : 75
    public static let minSize: CGFloat = 25
    public static let maxSize: CGFloat = 350
}
