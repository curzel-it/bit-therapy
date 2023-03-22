import math
from typing import List
from yage.models.capability import Capability
from yage.models.collisions import Collision, CollisionSide
from yage.models.entity_state import EntityState
from yage.utils.geometry import Vector


class BounceOnLateralCollisions(Capability):
    def do_update(self, collisions: List[Collision], time: float):
        if self.subject.is_ephemeral or self.subject.state != EntityState.MOVE:
            return
        angle = self.bouncing_angle(self.subject.direction.radians, collisions)
        if angle is None:
            return
        self.subject.direction = Vector.from_radians(angle)

    def bouncing_angle(self, current_angle: float, collisions: List[Collision]) -> float:
        target_side = self.target_side()
        valid_collisions = [c for c in collisions if c.other.is_static]
        if not target_side:
            return None
        if not _contains_overlap_on_side(valid_collisions, target_side):
            return None
        if _contains_overlap_on_side(valid_collisions, target_side.opposite):
            return None
        return math.pi - current_angle

    def target_side(self) -> CollisionSide:
        direction = self.subject.direction.dx
        if direction < -0.0001:
            return CollisionSide.LEFT
        if direction > 0.0001:
            return CollisionSide.RIGHT
        return None


def _contains_overlap_on_side(collisions, target_side) -> bool:
    valid_collisions = filter(
        lambda c: not c.is_ephemeral and c.is_overlapping, collisions)
    return any(target_side in c.sides() for c in valid_collisions)
