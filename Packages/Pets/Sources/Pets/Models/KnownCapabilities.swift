//
// Pet Therapy.
//

import Foundation
import Yage
import YageLive

class PetsCapabilitiesDiscoveryService: CapabilitiesDiscoveryService {
    static let shared = PetsCapabilitiesDiscoveryService()
    
    let capabilities: [String: Capability.Type] = [
        "AnimatedSprite": AnimatedSprite.self,
        "AnimationsProvider": AnimationsProvider.self,
        "AutoRespawn": AutoRespawn.self,
        "BounceOnLateralCollisions": BounceOnLateralCollisions.self,
        "FlipHorizontallyWhenGoingLeft": FlipHorizontallyWhenGoingLeft.self,
        "LinearMovement": LinearMovement.self,
        "PetsSpritesProvider": PetsSpritesProvider.self,
        "RandomAnimations": RandomAnimations.self,
        "Rotating": Rotating.self,
        "GetsAngryWhenMeetingOtherCats": GetsAngryWhenMeetingOtherCats.self,
        "WallCrawler": WallCrawler.self
    ]
    
    func capability(for id: String) -> Capability? {
        capabilities[id]?.init()
    }
}
