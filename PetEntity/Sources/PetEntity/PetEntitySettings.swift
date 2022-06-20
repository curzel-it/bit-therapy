//
// Pet Therapy.
//

import AppKit
import AppState
import DesignSystem
import Pets
import Biosphere

// MARK: - Id

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
    
    static func speed(for species: Pet, size: CGFloat) -> CGFloat {
        let sizeRatio = size / PetSize.defaultSize
        let multiplier = AppState.global.speedMultiplier
        return baseSpeed * species.speed * sizeRatio * multiplier
    }
}
// MARK: - Initial Frame

extension PetEntity {
    
    static func initialFrame(in habitatBounds: CGRect, prefers: CGSize?) -> CGRect {
        let size = prefers ?? CGSize(square: AppState.global.petSize)
        let position = habitatBounds
            .bottomLeft
            .offset(x: habitatBounds.width/4)
            .offset(y: -size.height)
        
        return CGRect(origin: position, size: size)
    }
}

// MARK: - Behaviors

extension Pet {
    
    public func movementCapabilities() -> [Capability.Type] {
        switch movement.type {
        case .fly: return [
            LinearMovement.self,
            BounceOffLateralBounds.self
        ]            
        case .walk: return [
            LinearMovement.self,
            BounceOffLateralBounds.self,
            PetGravity.self
        ]
        case .wallCrawler: return [
            LinearMovement.self,
            WallCrawler.self
        ]
        }
    }
}
