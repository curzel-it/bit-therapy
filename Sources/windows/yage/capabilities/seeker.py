from enum import Enum
from typing import List, Optional
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point, Vector
from yage.utils.logger import Logger


class SeekerTargetPosition(Enum):
    CENTER = 'center'
    ABOVE = 'above'


class SeekerState(Enum):
    CAPTURED = 'captured'
    ESCAPED = 'escaped'
    FOLLOWING = 'following'
    LOST = 'lost'

    def __repr__(self):
        if self == SeekerState.CAPTURED:
            return 'Captured'
        elif self == SeekerState.ESCAPED:
            return 'Escaped'
        elif self == SeekerState.LOST:
            return 'Lost'
        else:
            return 'Following'


class Seeker(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.target_entity: Optional[Entity] = None
        self.target_position: SeekerTargetPosition = SeekerTargetPosition.CENTER
        self.target_offset = Point(0, 0)
        self.auto_adjust_speed = False
        self.min_distance = 5
        self.max_distance = 20
        self.base_speed = subject.speed
        self.target_reached = False
        self.report = lambda state, distance: None

    def follow(self, target: Entity, **kwargs):
        self.target_entity = target
        self.subject.state = EntityState.MOVE
        if position := kwargs.get('position'):
            self.target_position = position
        if offset := kwargs.get('offset'):
            self.target_offset = offset
        if auto_adjust_speed := kwargs.get('auto_adjust_speed'):
            self.auto_adjust_speed = auto_adjust_speed
        if min_distance := kwargs.get('min_distance'):
            self.min_distance = min_distance
        if max_distance := kwargs.get('max_distance'):
            self.max_distance = max_distance
        if on_update := kwargs.get('on_update'):
            self.report = on_update

    def kill(self, autoremove=True):
        Logger.log(self.tag, "Killed")
        super().kill(autoremove)
        self.target_entity = None
        self.report = lambda state, distance: None

    def do_update(self, collisions: List[Collision], time: float):
        if target := self._target_point():
            distance = self.subject.frame.origin.distance(target)
            self._adjust_speed(distance)
            self._adjust_direction(target, distance)
            self._check_target_reached(distance)
        else:
            Logger.log(self.tag, "Target lost...")
            self.report(SeekerState.LOST, None)

    def _check_target_reached(self, distance: float):
        if not self.target_reached:
            if distance < self.min_distance:
                self.target_reached = True
                self.report(SeekerState.CAPTURED, None)
            else:
                self.report(SeekerState.FOLLOWING, distance)
        elif distance > self.max_distance:
            self.target_reached = False
            self.report(SeekerState.ESCAPED, None)

    def _adjust_direction(self, target: Point, distance: float):
        if distance < self.min_distance:
            self.subject.direction = Vector(0, 0)
        else:
            self.subject.direction = Vector(
                (target.x - self.subject.frame.origin.x) / distance,
                (target.y - self.subject.frame.origin.y) / distance
            )

    def _adjust_speed(self, distance: float):
        if not self.auto_adjust_speed:
            return
        if distance < self.min_distance:
            self.subject.speed = self.base_speed * 0.25
        elif distance < self.max_distance:
            self.subject.speed = self.base_speed * 0.5
        else:
            self.subject.speed = self.base_speed

    def _target_point(self) -> Optional[Point]:
        if not self.target_entity.is_alive:
            return None
        frame = self.subject.frame
        target_frame = self.target_entity.frame

        center_x = target_frame.min_x + target_frame.width / 2 - frame.width / 2
        center_y = target_frame.min_y + target_frame.height / 2 - frame.height / 2

        if self.target_position == SeekerTargetPosition.CENTER:
            x = center_x + self.target_offset.x
            y = center_y + self.target_offset.y
        elif self.target_position == SeekerTargetPosition.ABOVE:
            x = center_x + self.target_offset.x
            y = target_frame.min_y - frame.height + self.target_offset.y

        return Point(x, y)
