from typing import Optional
from onscreen import GetsAngryWhenMeetingOtherCats, LeavesBreadcrumbs, LeavesPoopStains, RandomPlatformJumper, SleepingPlace
from yage.capabilities import *
from yage.models import *
from .sprites import MySpritesProvider

class MyCapabilities(CapabilitiesDiscoveryService):
    def __init__(self):
        self.capabilities = {
            "AnimatedSprite": AnimatedSprite,
            "AnimationsProvider": AnimationsProvider,
            "AnimationsScheduler": AnimationsScheduler,
            "AutoRespawn": AutoRespawn,
            "BounceOnLateralCollisions": BounceOnLateralCollisions,
            "Draggable": Draggable,
            "FlipHorizontallyWhenGoingLeft": FlipHorizontallyWhenGoingLeft,
            "GetsAngryWhenMeetingOtherCats": GetsAngryWhenMeetingOtherCats,
            "Gravity": Gravity,
            "LeavesBreadcrumbs": LeavesBreadcrumbs,
            "LeavesPoopStains": LeavesPoopStains,
            "LinearMovement": LinearMovement,
            "PetsSpritesProvider": MySpritesProvider,
            "RandomPlatformJumper": RandomPlatformJumper,
            "Rotating": Rotating,
            "Seeker": Seeker,
            "SleepingPlace": SleepingPlace,
            "WallCrawler": WallCrawler
        }

    def capability(self, id: str) -> Optional[Capability]:
        return self.capabilities.get(id)