from typing import List
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point


class LinearMovement(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        subject.movement = self

    def do_update(self, collisions: List[Collision], time: float):
        if not self.can_move:
            return
        distance = self.movement_given_time(time)
        new_position = self.subject.frame.origin.offset(point=distance)
        self.subject.frame.origin = new_position

    def movement_given_time(self, time: float) -> Point:
        return Point(
            self.subject.direction.dx * self.subject.speed * time,
            self.subject.direction.dy * self.subject.speed * time
        )

    @property
    def can_move(self) -> bool:
        return self.subject.state in [EntityState.MOVE, EntityState.FREE_FALL]
