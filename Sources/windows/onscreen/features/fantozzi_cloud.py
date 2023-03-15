from random import randint
from onscreen.models.pet_entity import PetEntity
from PyQt6.QtCore import QTimer
from yage import *


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
        seeker = Seeker()
        self.cloud.install(seeker)
        seeker.follow(
            self.target,
            position=SeekerTargetPosition.ABOVE,
            offset=Point(0, y_offset),
            auto_adjust_speed=True
        )

    def _schedule_cleanup(self, cloud: Entity, world: World):
        duration = int(QTimer.random(60000, 120000))
        QTimer.singleShot(duration, lambda: self._cleanup(cloud, world))

    def _cleanup(self, cloud: Entity, world: World):
        if cloud in world.children:
            cloud.kill()
            world.children.remove(cloud)

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


class ScreenEnvironment:
    def schedule_rainy_cloud(self):
        duration = randint(0*60, 5*60) * 1000
        QTimer.singleShot(duration, lambda: self._cleanup())

    def _schedule_rainy_cloud(self):
        if not self.settings.random_events:
            return
        victim = self.random_pet()
        if victim is None:
            return
        self.rainy_cloud_use_case.start(victim, self)
