from typing import Optional
from onscreen.features.gets_angry_when_meeting_other_cats import GetsAngryWhenMeetingOtherCats
from onscreen.features.leaves_poop_stains import LeavesPoopStains
from onscreen.features.leaves_traces_while_walking import LeavesTracesWhileWalking
from onscreen.features.random_platform_jumper import RandomPlatformJumper
from onscreen.features.sleeping_place import SleepingPlace
from onscreen.models.sprites import PetsSpritesProvider
from yage.capabilities.animated_sprite import AnimatedSprite
from yage.capabilities.animations_provider import AnimationsProvider
from yage.capabilities.animations_scheduler import AnimationsScheduler
from yage.capabilities.auto_respawn import AutoRespawn
from yage.capabilities.bounce_on_lateral_collisions import BounceOnLateralCollisions
from yage.capabilities.draggable import Draggable
from yage.capabilities.flip_horizontally_when_going_left import FlipHorizontallyWhenGoingLeft
from yage.capabilities.gravity import Gravity
from yage.capabilities.linear_movement import LinearMovement
from yage.capabilities.rotating import Rotating
from yage.capabilities.seeker import Seeker
from yage.capabilities.wall_crawler import WallCrawler
from yage.models.capability import CapabilitiesDiscoveryService, Capability


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

    def capability(self, capability_id: str) -> Optional[Capability]:
        return self.capabilities.get(capability_id)
