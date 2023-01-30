import Combine
import Schwifty
import SwiftUI
import Yage

open class PetEntity: Entity {
    private var settings: AppState { AppState.global }

    public init(of species: Species, in worldBounds: CGRect) {
        super.init(
            species: species,
            id: PetEntity.id(for: species),
            frame: PetEntity.initialFrame(in: worldBounds, size: AppState.global.petSize),
            in: worldBounds
        )
        loadProperties()
        installAdditionalCapabilities()
    }

    func loadProperties() {
        resetSpeed()
        setInitialPosition()
        setInitialDirection()
        setGravity()
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

// MARK: - Incremental Id

extension PetEntity {
    static func id(for species: Species) -> String {
        nextNumber += 1
        return "\(species.id)-\(nextNumber)"
    }

    private static var nextNumber = 0
}

// MARK: - Speed

public extension PetEntity {
    internal static let baseSpeed: CGFloat = 30

    static func speed(for species: Species, size: CGFloat, settings: CGFloat) -> CGFloat {
        species.speed * speedMultiplier(for: size) * settings
    }

    static func speedMultiplier(for size: CGFloat) -> CGFloat {
        let sizeRatio = size / PetSize.defaultSize
        return baseSpeed * sizeRatio
    }
}

// MARK: - Initial Frame

extension PetEntity {
    static func initialFrame(in worldBounds: CGRect, size: CGFloat) -> CGRect {
        let randomX = worldBounds.width * CGFloat.random(in: 0.2 ... 0.8)
        return CGRect(origin: CGPoint(x: randomX, y: 30), size: CGSize(square: size))
    }
}

// MARK: - Pet Size

public struct PetSize {
    public static let defaultSize: CGFloat = 75
    public static let minSize: CGFloat = 30
    public static let maxSize: CGFloat = 350
}
