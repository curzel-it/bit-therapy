import DesignSystem
import SwiftUI
import Yage

// MARK: - Incremental Id

extension PetEntity {
    static func id(for pet: Pet) -> String {
        nextNumber += 1
        return "\(pet.id)-\(nextNumber)"
    }
    
    private static var nextNumber = 0
}

// MARK: - Speed

extension PetEntity {
    static let baseSpeed: CGFloat = 30
    
    public static func speed(for species: Pet, size: CGFloat, settings: CGFloat) -> CGFloat {
        species.speed * speedMultiplier(for: size) * settings
    }
    
    public static func speedMultiplier(for size: CGFloat) -> CGFloat {
        let sizeRatio = size / PetSize.defaultSize
        return baseSpeed * sizeRatio
    }
}

// MARK: - Initial Frame

extension PetEntity {
    static func initialFrame(in worldBounds: CGRect, size: CGFloat) -> CGRect {
        CGRect(origin: .zero, size: CGSize(square: size))
    }
}

// MARK: - Default Capabilities

extension Capabilities {
    public static func petAnimations() -> Capabilities {
        [PetAnimationsProvider(), PetSpritesProvider()]
    }
    
    public static func defaultsCrawler() -> Capabilities {
        crawler() + petAnimations()
    }
    
    public static func defaults() -> Capabilities {
        walker() + petAnimations()
    }
}
