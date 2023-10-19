from random import randint
from PyQt6.QtCore import QTimer
from onscreen.models.pet_entity import PetEntity
from yage.capabilities.seeker import Seeker, SeekerTargetPosition
from yage.models.entity import Entity
from yage.models.species import Species
from yage.models.world import World
from yage.utils.geometry import Point


class RainyCloudUseCase:
    def __init__(self):
        self.target = None
        self.cloud = None
        self._completion_date = None

    def start(self, target: Entity, world: World):
        self.target = target
        self.cloud = self._build_cloud(target.frame.top_left, world)
        self._setup_seeker()
        self._schedule_completion()

    def _schedule_completion(self):
        duration = randint(60, 120) * 1000
        QTimer.singleShot(duration, lambda: self._cleanup())

    def _build_cloud(self, origin: Point, world: World) -> Entity:
        cloud = PetEntity(self._cloud_species(), world)
        cloud.frame.set_size(cloud.frame.size() * 2)
        cloud.frame.set_top_left(origin)
        cloud.is_ephemeral = True
        world.children.append(cloud)
        return cloud

    def _setup_seeker(self):
        y_offset = self.cloud.frame.height() - self.target.frame.height()
        seeker = self.cloud.install(Seeker)
        seeker.follow(
            self.target,
            position=SeekerTargetPosition.ABOVE,
            offset=Point(0, y_offset),
            auto_adjust_speed=True
        )

    def _cleanup(self):
        if self.cloud in self.cloud.world.children:
            self.cloud.kill()
            self.cloud.world.children.remove(self.cloud)

    def _cloud_species(self):
        return Species(
            id="fantozzi",
            capabilities=[
                "AnimatedSprite",
                "AnimationsProvider",
                "LinearMovement",
                "PetsSpritesProvider"
            ],
            drag_path="front",
            movement_path="front",
            speed=2,
            z_index=200
        )