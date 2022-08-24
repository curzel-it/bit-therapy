//
// Pet Therapy.
//

import Biosphere
import DesignSystem
import Sprites
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
        let position = habitatBounds
            .bottomLeft
            .offset(x: habitatBounds.width/4)
            .offset(y: -size)
        
        return CGRect(origin: position, size: CGSize(square: size))
    }
}

// MARK: - Default Capabilities

extension Capabilities {
    
    static let defaultsCrawler: Capabilities = [
        LinearMovement.self,
        ReactToHotspots.self,
        RandomAnimations.self,
        WallCrawler.self,
        AnimatedSprite.self,
        PetSpritesProvider.self
    ]
    
    static let defaultsNoGravity: Capabilities = [
        LinearMovement.self,
        BounceOffLateralCollisions.self,
        FlipHorizontallyWhenGoingLeft.self,
        ReactToHotspots.self,
        RandomAnimations.self,
        AnimatedSprite.self,
        PetSpritesProvider.self
    ]
    
    static let defaultsWithGravity: Capabilities = defaultsNoGravity + [Gravity.self]
}
