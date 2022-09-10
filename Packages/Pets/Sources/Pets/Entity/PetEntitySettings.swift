import DesktopKit
import DesignSystem
import SwiftUI

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
    
    public static func speed(for species: Pet, size: CGFloat) -> CGFloat {
        species.speed * speedMultiplier(for: size)
    }
    
    public static func speedMultiplier(for size: CGFloat) -> CGFloat {
        let sizeRatio = size / PetSize.defaultSize
        return baseSpeed * sizeRatio
    }
}

// MARK: - Initial Frame

extension PetEntity {
    
    static func initialFrame(in habitatBounds: CGRect, size: CGFloat) -> CGRect {
        return CGRect(origin: .zero, size: CGSize(square: size))
    }
}

// MARK: - Default Capabilities

extension DKCapabilities {
    private static func petsStuff() -> DKCapabilities {
        [PetAnimationsProvider(), PetSpritesProvider()]
    }
    public static func defaultsCrawler() -> DKCapabilities {
        xxdefaultsCrawler() + petsStuff()
    }
    public static func defaults() -> DKCapabilities {
        xxdefaults() + petsStuff()
    }
}
