from enum import Enum
import math
from yage.utils.geometry import Rect


class Collision:
    def __init__(self, source, other, intersection: 'Rect'):
        self.intersection = intersection
        self.is_ephemeral = other.is_ephemeral
        self.is_overlapping = intersection.width >= 1 and intersection.height >= 1
        self.other = other
        self.source = source

    @property
    def other_id(self):
        return self.other.id

    @property
    def other_body(self):
        return self.other.frame

    @property
    def source_body(self):
        return self.source.frame

    def __repr__(self):
        return f'Collision with {self.other.id} at {self.intersection}'

    def sides(self):
        sides = []
        body_center = self.source_body.center
        angle = body_center.angle_to(self.intersection.center)

        def in_between(angle, pi1, pi2):
            if pi1 == 2 or pi2 == 2 or pi1 == 0 or pi2 == 0:
                if angle == 0 or abs(angle - 2 * math.pi) < 0.0001:
                    return True
            return angle >= pi1 * math.pi and angle <= pi2 * math.pi

        intersection_edges = [
            c for c in self.intersection.corners if c.is_on_edge(self.source_body)]
        touches_top = any(body_center.y < c.y <=
                          self.source_body.max_y for c in intersection_edges)
        touches_right = any(body_center.x < c.x <=
                            self.source_body.max_x for c in intersection_edges)
        touches_bottom = any(body_center.y > c.y >=
                             self.source_body.min_y for c in intersection_edges)
        touches_left = any(body_center.x > c.x >=
                           self.source_body.min_x for c in intersection_edges)

        if touches_top and in_between(angle, 0.0, 1.0):
            sides.append(CollisionSide.TOP)
        if touches_right and (in_between(angle, 0.0, 0.5) or in_between(angle, 1.5, 2.0)):
            sides.append(CollisionSide.RIGHT)
        if touches_bottom and in_between(angle, 1.0, 2.0):
            sides.append(CollisionSide.BOTTOM)
        if touches_left and in_between(angle, 0.5, 1.5):
            sides.append(CollisionSide.LEFT)

        return sides


class CollisionSide(Enum):
    TOP = "top"
    RIGHT = "right"
    BOTTOM = "bottom"
    LEFT = "left"

    @property
    def opposite(self) -> 'CollisionSide':
        if self == CollisionSide.TOP:
            return CollisionSide.BOTTOM
        elif self == CollisionSide.BOTTOM:
            return CollisionSide.TOP
        elif self == CollisionSide.LEFT:
            return CollisionSide.RIGHT
        else:
            return CollisionSide.LEFT
