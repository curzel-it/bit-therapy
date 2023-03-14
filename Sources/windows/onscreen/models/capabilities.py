from typing import Optional
from onscreen.features.gets_angry_when_meeting_other_cats import GetsAngryWhenMeetingOtherCats
from onscreen.features.leaves_poop_stains import LeavesPoopStains
from onscreen.features.leaves_traces_while_walking import LeavesTracesWhileWalking
from onscreen.features.random_platform_jumper import RandomPlatformJumper
from onscreen.features.sleeping_place import SleepingPlace
from onscreen.models.sprites import PetsSpritesProvider
from yage.capabilities import *
from yage.models import *

class PetsCapabilities(CapabilitiesDiscoveryService):
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
            "LeavesPoopStains": LeavesPoopStains,
            "LeavesTracesWhileWalking": LeavesTracesWhileWalking,
            "LinearMovement": LinearMovement,
            "PetsSpritesProvider": PetsSpritesProvider,
            "RandomPlatformJumper": RandomPlatformJumper,
            "Rotating": Rotating,
            "Seeker": Seeker,
            "SleepingPlace": SleepingPlace,
            "WallCrawler": WallCrawler
        }

    def capability(self, id: str) -> Optional[Capability]:
        return self.capabilities.get(id)