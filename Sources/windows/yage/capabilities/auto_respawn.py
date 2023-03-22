import random
from typing import List
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.models.hotspots import BOUNDS_THICKNESS
from yage.utils.geometry import Point, Rect, Vector
from yage.utils.logger import Logger


class AutoRespawn(Capability):
    def do_update(self, collisions: List[Collision], time: float):
        if self.subject.state == EntityState.DRAG:
            return
        if self.is_within_bounds(self.subject.frame.origin):
            return
        Logger.log(self.tag, "Outside of bounds, teleporting...")
        self.teleport()

    def teleport(self):
        world_width = self.subject.world_bounds.width
        random_x = world_width * random.uniform(0.2, 0.8)
        self.subject.frame.origin = Point(x=random_x, y=30)
        self.subject.direction = Vector(dx=1, dy=0)
        self.subject.state = EntityState.MOVE

    def outer_bounds(self):
        bounds = self.subject.world.bounds if self.subject else Rect.zero()
        bounds = bounds.offset(x=-bounds.min_x, y=-bounds.min_y)
        bounds = bounds.inset_by(-BOUNDS_THICKNESS * 5)
        return bounds

    def is_within_bounds(self, point: Point) -> bool:
        return self.outer_bounds().contains(point)
