import random
from config.config import Config
from di.di import Dependencies
from onscreen.models.pet_size import PetSize
from yage.capabilities import Gravity
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.models.species import Species
from yage.models.world import World
from yage.utils.geometry import Point, Rect, Vector


class PetEntity(Entity):
    def __init__(self, species: Species, world: World):
        self.config = Dependencies.instance(Config)
        pet_size = self.config.pet_size.value
        gravity_enabled = self.config.gravity_enabled.value

        super().__init__(
            species,
            PetEntity.next_id(species),
            Rect(0, 0, pet_size, pet_size),
            world
        )
        self.reset_speed()
        self.place_in_random_position()
        self._set_initial_direction()
        self.set_gravity_enabled(gravity_enabled)

    def reset_speed(self):
        self.speed = PetEntity.default_speed(
            self.species,
            self.frame.width,
            self.config.speed_multiplier.value
        )

    def place_in_random_position(self):
        random_x = random.uniform(0.1, 0.75) * self.world_bounds.width
        self.frame.origin = Point(random_x, 5)

    def _set_initial_direction(self):
        self.direction = Vector(1, 0)

    def set_gravity_enabled(self, enabled: bool):
        gravity = self.capability(Gravity)
        if not gravity:
            return
        gravity.is_enabled = enabled
        if not enabled:
            if self.direction.dy > 0:
                self.direction = Vector(1, 0)
            self.state = EntityState.MOVE

    @classmethod
    def initial_frame(cls) -> Rect:
        config = Dependencies.instance(Config)
        return Rect(0, 0, config.pet_cize, config.pet_cize)

    @classmethod
    def default_speed(cls, species: Species, size: float, settings: float) -> float:
        return species.speed * cls.speed_multiplier(size) * settings

    @classmethod
    def speed_multiplier(cls, size: float) -> float:
        size_ratio = size / PetSize.default_size
        return 30 * size_ratio

    @classmethod
    def next_id(cls, species):
        if not hasattr(cls, 'incremental_id'):
            cls.incremental_id = 0
        cls.incremental_id += 1
        return f'{species.id}-{cls.incremental_id}'
