import math
from yage.models.capability import Capability
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point, Vector


class WallCrawler(Capability):
    def do_update(self, collisions, time):
        if self.subject.state != EntityState.MOVE:
            return

        direction = self.subject.direction

        if self._is_going_up(direction) and self.touches_screen_top():
            self._crawl_along_top_bound()
            return
        if self._is_going_right(direction) and self.touches_screen_right():
            self._crawl_up_right_bound()
            return
        if self._is_going_down(direction) and self.touches_screen_bottom():
            self._crawl_along_bottom_bound()
            return
        if self._is_going_left(direction) and self.touches_screen_left():
            self._crawl_down_left_bound()
            return

    def _is_going_up(self, direction):
        return direction.dy < -0.0001

    def _is_going_right(self, direction):
        return direction.dx > 0.0001

    def _is_going_down(self, direction):
        return direction.dy > 0.0001

    def _is_going_left(self, direction):
        return direction.dx < -0.0001

    def _crawl_along_top_bound(self):
        direction = Vector(-1, 0)
        self.subject.direction = direction
        self.subject.frame.origin = Point(self.subject.frame.origin.x, 0)
        rotation = self.subject.rotation
        if rotation:
            rotation.is_flipped_horizontally = True
            rotation.is_flipped_vertically = True
            rotation.z_angle = 0

    def _crawl_up_right_bound(self):
        direction = Vector(0, -1)
        self.subject.direction = direction
        self.subject.frame.origin = Point(
            self.subject.world_bounds.width - self.subject.frame.width,
            self.subject.frame.origin.y
        )
        rotation = self.subject.rotation
        if rotation:
            rotation.is_flipped_horizontally = False
            rotation.is_flipped_vertically = False
            rotation.z_angle = math.pi * 0.5

    def _crawl_along_bottom_bound(self):
        direction = Vector(1, 0)
        self.subject.direction = direction
        self.subject.frame.origin = Point(
            self.subject.frame.origin.x,
            self.subject.world_bounds.height - self.subject.frame.height
        )
        rotation = self.subject.rotation
        if rotation:
            rotation.is_flipped_horizontally = False
            rotation.is_flipped_vertically = False
            rotation.z_angle = 0

    def _crawl_down_left_bound(self):
        direction = Vector(0, 1)
        self.subject.direction = direction
        self.subject.frame.origin = Point(0, self.subject.frame.origin.y)
        rotation = self.subject.rotation
        if rotation:
            rotation.is_flipped_horizontally = False
            rotation.is_flipped_vertically = False
            rotation.z_angle = math.pi * 1.5

    def touches_screen_top(self):
        return self.subject.frame.min_y <= 0

    def touches_screen_right(self):
        bound = self.subject.world_bounds.width
        return self.subject.frame.max_x >= bound

    def touches_screen_bottom(self):
        bound = self.subject.world_bounds.height
        return self.subject.frame.max_y >= bound

    def touches_screen_left(self):
        return self.subject.frame.min_x <= 0
