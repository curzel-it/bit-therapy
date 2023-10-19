from typing import List
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.utils.geometry import Vector


class FlipHorizontallyWhenGoingLeft(Capability):
    def do_update(self, collisions: List[Collision], time: float):
        animation, _ = self.subject.animation()
        if animation and animation.facing_direction is not None:
            self._flip_towards(animation.facing_direction)
        else:
            self._flip_towards(self.subject.direction)

    def _flip_towards(self, direction: Vector):
        self.subject.rotation.is_flipped_horizontally = direction.dx < -0.0001
