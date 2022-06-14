//
// Pet Therapy.
//

import DesignSystem
import Physics
import AppKit

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
    
    static func initialFrame(for preferredSize: CGSize?, in bounds: CGRect) -> CGRect {
        let size = preferredSize ?? CGSize(square: AppState.global.petSize)
        let position = bounds
            .bottomLeft
            .offset(x: bounds.width/4)
            .offset(y: -size.height)
        
        return CGRect(origin: position, size: size)
    }
}

// MARK: - Behaviors

extension PetEntity {
    
    static func behaviors(for pet: Pet) -> [EntityBehavior.Type] {
        var behaviors = [
            MovesLinearly.self,
            ChangesStateOnHotspot.self,
            ResumeMovementAfterAnimations.self,
            BouncesOnCollision.self
        ]
        if !pet.doesFly {
            behaviors.append(IsAffectedByGravity.self)
        }
        return behaviors
    }
}
