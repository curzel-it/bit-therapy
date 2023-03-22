from typing import List
from yage.models.animations import EntityAnimationPosition
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point, Vector
from yage.utils import Logger


class Gravity(Capability):
    fall_direction = Vector(0, 8)

    def do_update(self, collisions: List[Collision], time: float):
        if self.subject.state == EntityState.DRAG:
            return False
        if self._animation_requires_no_gravity():
            return False

        ground_level = self._ground_level(collisions)
        if ground_level is None:
            self._start_falling_if_needed()
        else:
            self._on_ground_reached(ground_level)

    @property
    def is_falling(self) -> bool:
        return self.subject.state == EntityState.FREE_FALL

    def _ground_level(self, collisions: List[Collision]) -> float:
        body = self.subject.frame
        required_surface_contact = body.width / 2

        ground_collisions = self._ground_collisions(body, collisions)
        ground_level = self._ground_level_from_collisions(ground_collisions)

        def touches_ground(collision):
            return collision.intersection.min_y == ground_level

        surface_contact = sum(
            [c.intersection.width for c in ground_collisions if touches_ground(c)])
        return ground_level if surface_contact > required_surface_contact else None

    def _ground_collisions(self, body, collisions):
        def is_ground_collision(c):
            return c.other.is_static and body.min_y < c.intersection.min_y and not c.is_ephemeral
        return [c for c in collisions if is_ground_collision(c)]

    def _ground_level_from_collisions(self, ground_collisions):
        try:
            return sorted([c.intersection.min_y for c in ground_collisions])[-1]
        except IndexError:
            return None

    def _on_ground_reached(self, ground_level: float):
        target_y = ground_level - self.subject.frame.height
        is_landing = self.is_falling
        is_raising = self.subject.frame.min_y != target_y and not self.is_falling

        if is_landing or is_raising:
            self.subject.frame.origin = Point(
                self.subject.frame.origin.x, target_y)

        if is_landing:
            Logger.log(self.tag, f"Safely landed at {target_y}")
            self.subject.movement.is_enabled = True
            self.subject.direction = Vector(1, 0)
            self.subject.state = EntityState.MOVE

    def _start_falling_if_needed(self) -> bool:
        if self.is_falling:
            return False
        self.subject.state = EntityState.FREE_FALL
        self.subject.direction = Gravity.fall_direction
        self.subject.speed = 14
        self.subject.movement.is_enabled = True
        Logger.log(self.tag, 'Started falling')
        return True

    def _animation_requires_no_gravity(self) -> bool:
        animation, _ = self.subject.animation()
        if not animation:
            return False
        if animation.position != EntityAnimationPosition.FROM_ENTITY_BOTTOM_LEFT:
            return True
        if animation.size is not None:
            return True
        return False
