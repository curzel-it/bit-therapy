import Combine
import Schwifty
import SwiftUI
import Yage

open class PetEntity: Entity {
    @Inject private var settings: AppConfig

    public init(of species: Species, in world: World) {
        super.init(
            species: species,
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(),
            in: world
        )
        resetSpeed()
        setGravity()
        setInitialPosition()
        setInitialDirection()
        installAdditionalCapabilities()
    }
    
    private func installAdditionalCapabilities() {
        install(MouseDraggable())
        install(ShowMenuOnRightClick())
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

    public var supportsGravity: Bool {
        capability(for: WallCrawler.self) == nil
    }

    public func setGravity() {
        setGravity(enabled: settings.gravityEnabled && supportsGravity)
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

    static func initialFrame() -> CGRect {
        @Inject var appConfig: AppConfig
        return CGRect(square: appConfig.petSize)
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
