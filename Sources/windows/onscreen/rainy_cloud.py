from datetime import datetime, timedelta
import random
from onscreen.pet_entity import PetEntity
from yage.capabilities.seeker import Seeker, SeekerTargetPosition
from yage.models.entity import Entity
from yage.models.species import Species
from yage.utils.geometry import Point, Size
from yage.utils.logger import Logger

class RainyCloud(PetEntity):
    def __init__(self, position, world):
        super().__init__(self._species(), world)
        Logger.log(self.id, "Created cloud...")
        self.frame.size = Size(self.frame.size.width * 2, self.frame.size.height * 2)
        self.frame.origin = position
        self.is_ephemeral = True
        self._expiration_date = None

    @staticmethod
    def start(target: Entity):        
        cloud = RainyCloud(target.frame.origin, target.world)
        target.world.children.append(cloud)
        cloud.follow(target)

    def follow(self, target: Entity):
        Logger.log(self.id, "Started following", target.id)
        duracy = random.randint(60, 120)
        self._expiration_date = datetime.now() + timedelta(seconds=duracy)
        y_offset = self.frame.height - target.frame.height
        self.capability(Seeker).follow(
            target,
            position=SeekerTargetPosition.ABOVE,
            offset=Point(0, y_offset),
            auto_adjust_speed=True,
            on_update=None
        )

    def update(self, collisions, time): 
        if self._expiration_date and self._expiration_date < datetime.now():
            self._expiration_date = None
            self.world.children.remove(self)
            self.kill()
        else:
            super().update(collisions, time)

    def _species(self) -> Species: 
        return Species(
            "fantozzi",
            [],
            [
                "AnimatedSprite",
                "AnimationsProvider",
                "LinearMovement",
                "PetsSpritesProvider",
                "Seeker"
            ],
            "front",
            10,
            "front",
            2,
            [],
            200
        )