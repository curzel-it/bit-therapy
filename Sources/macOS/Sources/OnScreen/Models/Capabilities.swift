import Foundation
import Yage

class PetsCapabilitiesDiscoveryService: CapabilitiesDiscoveryService {
    let capabilities: [String: Capability.Type] = [
        "AnimatedSprite": AnimatedSprite.self,
        "AnimationsProvider": AnimationsProvider.self,
        "AnimationsScheduler": AnimationsScheduler.self,
        "AutoRespawn": AutoRespawn.self,
        "BounceOnLateralCollisions": BounceOnLateralCollisions.self,
        "Draggable": Draggable.self,
        "FlipHorizontallyWhenGoingLeft": FlipHorizontallyWhenGoingLeft.self,
        "GetsAngryWhenMeetingOtherCats": GetsAngryWhenMeetingOtherCats.self,
        "Gravity": Gravity.self,
        "LeavesPoopStains": LeavesPoopStains.self,
        "LinearMovement": LinearMovement.self,
        "MouseChaser": MouseChaser.self,
        "PetsSpritesProvider": PetsSpritesProvider.self,
        "RandomPlatformJumper": RandomPlatformJumper.self,
        "Rotating": Rotating.self,
        "ShowsMenuOnRightClick": ShowsMenuOnRightClick.self,
        "SleepingPlace": SleepingPlace.self,
        "WallCrawler": WallCrawler.self
    ]
    
    func capability(for id: String) -> Capability? {
        capabilities[id]?.init()
    }
}
