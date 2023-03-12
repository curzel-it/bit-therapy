import random
from config.config import Config
from di import *
from yage.capabilities import Gravity
from yage.models import *
from yage.utils.geometry import *

class PetEntity(Entity):
    def __init__(self, species, world):
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
        config = self.config.speed_multiplier.value
        size = self.frame.size.width / 75.0
        self.speed = config * 30.0 * self.species.speed * size

    def place_in_random_position(self):
        random_x = random.uniform(0.1, 0.75) * self.world_bounds.width
        self.frame.origin = Point(random_x, self.world_bounds.height+5)

    def _set_initial_direction(self):
        self.direction = Vector(1, 0)

    def set_gravity_enabled(self, enabled: bool):
        gravity = self.capability(Gravity)
        if not gravity: return
        gravity.is_enabled = enabled
        if not enabled:
            if self.direction.dy > 0:
                self.direction = Vector(1, 0)
            self.state = EntityState.MOVE

    @classmethod
    def next_id(cls, species):
        if not hasattr(cls, 'incremental_id'): cls.incremental_id = 0
        cls.incremental_id += 1
        return f'{species.id}-{cls.incremental_id}'
