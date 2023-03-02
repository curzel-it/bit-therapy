import Foundation
import Yage

class PetsCapabilitiesDiscoveryService: CapabilitiesDiscoveryService {
    let capabilities: [String: Capability.Type] = [
        "AnimatedSprite": AnimatedSprite.self,
        "AnimationsProvider": AnimationsProvider.self,
        "AnimationsScheduler": AnimationsScheduler.self,
        "AutoRespawn": AutoRespawn.self,
        "BounceOnLateralCollisions": BounceOnLateralCollisions.self,
        "SleepingPlace": SleepingPlace.self,
        "FlipHorizontallyWhenGoingLeft": FlipHorizontallyWhenGoingLeft.self,
        "GetsAngryWhenMeetingOtherCats": GetsAngryWhenMeetingOtherCats.self,
        "LeavesPoopStains": LeavesPoopStains.self,
        "LinearMovement": LinearMovement.self,
        "PetsSpritesProvider": PetsSpritesProvider.self,
        "Rotating": Rotating.self,
        "WallCrawler": WallCrawler.self
    ]
    
    func capability(for id: String) -> Capability? {
        capabilities[id]?.init()
    }
}
