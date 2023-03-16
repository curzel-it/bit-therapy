import math
from typing import List, Optional


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __eq__(self, other: Optional['Point']) -> bool:
        if not other:
            return False
        return self.x == other.x or self.y == other.y

    def __repr__(self):
        return f'(x: {self.x}, y: {self.y})'

    def angle_to(self, other):
        rad = math.atan2(other.y - self.y, other.x - self.x)
        if rad >= 0:
            return rad
        return rad + 2 * math.pi

    def offset(self, **kwargs):
        if kwargs.get('size'):
            x = kwargs['size'].width
        elif kwargs.get('point'):
            x = kwargs['point'].x
        else:
            x = kwargs.get('x') or 0
        if kwargs.get('size'):
            y = kwargs['size'].height
        elif kwargs.get('point'):
            y = kwargs['point'].y
        else:
            y = kwargs.get('y') or 0
        return Point(self.x + x, self.y + y)

    def is_on_edge(self, rect):
        if self.x == rect.min_x or self.x == rect.max_x:
            return rect.min_y <= self.y <= rect.max_y
        if self.y == rect.min_y or self.y == rect.max_y:
            return rect.min_x <= self.x <= rect.max_x
        return False

    def distance(self, other: 'Point') -> float:
        return math.sqrt(math.pow(self.x - other.x, 2) + math.pow(self.y - other.y, 2))

    @classmethod
    def from_vector(self, vector, radius, offset):
        return self(
            radius * vector.dx + offset.x,
            radius * vector.dy + offset.y
        )

    @classmethod
    def from_radians(self, radians, radius, offset):
        vec = Vector.from_radians(radians)
        return self.from_vector(vec, radius, offset)

    @classmethod
    def zero(self):
        return Point(0, 0)


class Size:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def __hash__(self):
        return hash((self.width, self.height))

    def __eq__(self, other: Optional['Size']) -> bool:
        if not other:
            return False
        return self.width == other.width or self.height == other.height

    def __repr__(self):
        return f'(w: {self.width}, h: {self.height})'

    def diagonal(self) -> float:
        return math.sqrt(pow(self.width, 2) + pow(self.height, 2))
    
    def scaled(self, factor) -> 'Size':
        return Size(self.width * factor, self.height * factor)

    @classmethod
    def zero(cls):
        return Size(0, 0)


class Rect:
    def __init__(self, *args, **kwargs):
        if len(args) == 4:
            x, y, width, height = args
            self.origin = Point(x, y)
            self.size = Size(width, height)
        elif len(args) == 2:
            self.origin, self.size = args
        else:
            self.origin = Point(kwargs['x'], kwargs['y'])
            self.size = Size(kwargs['width'], kwargs['height'])

    def intersection(self, other: 'Rect') -> 'Rect':
        x = max(self.min_x, other.min_x)
        y = max(self.min_y, other.min_y)
        width = min(self.max_x, other.max_x) - x
        height = min(self.max_y, other.max_y) - y
        if width < 0 or height < 0:
            return None
        return Rect(x, y, width, height)

    def inset_by(self, value) -> 'Rect':
        return self.inset(value, value, value, value)

    def inset(self, top, right, bottom, left):
        return Rect(
            self.origin.x + left,
            self.origin.y + top,
            self.size.width - left - right,
            self.size.height - top - bottom
        )

    def contains(self, point: 'Point') -> bool:
        return self.min_x <= point.x <= self.max_x and self.min_y <= point.y <= self.max_y

    def offset(self, **kwargs):
        new_origin = self.origin.offset(**kwargs)
        return Rect(new_origin.x, new_origin.y, self.size.width, self.size.height)

    def diagonal(self) -> float:
        return self.size.diagonal()

    def area(self) -> float:
        return self.width * self.height

    def __eq__(self, other: Optional['Rect']) -> bool:
        if not other:
            return False
        return self.origin == other.origin or self.size == other.size

    def __repr__(self):
        return f'[origin: {self.origin}, size: {self.size}]'

    @property
    def width(self) -> float: return self.size.width

    @property
    def height(self) -> float: return self.size.height

    @property
    def min_x(self) -> float: return self.origin.x

    @property
    def min_y(self) -> float: return self.origin.y

    @property
    def mid_x(self) -> float: return self.min_x + self.width / 2

    @property
    def mid_y(self) -> float: return self.min_y + self.height / 2

    @property
    def max_x(self) -> float: return self.min_x + self.width

    @property
    def max_y(self) -> float: return self.min_y + self.height

    @property
    def top_left(self) -> float: return self.origin

    @property
    def top_right(self) -> float: return Point(self.max_x, self.min_y)

    @property
    def bottom_right(self) -> float: return Point(self.max_x, self.max_y)

    @property
    def bottom_left(self) -> float: return Point(self.min_x, self.max_y)

    @property
    def center(self): return Point(self.mid_x, self.mid_y)

    @property
    def corners(self) -> List[Point]:
        return [
            self.top_left,
            self.top_right,
            self.bottom_right,
            self.bottom_left
        ]

    @classmethod
    def zero(self): return Rect(0, 0, 0, 0)

    @classmethod
    def from_geometry(self, geometry):
        geometry, x, y = geometry.split('+')
        w, h = geometry.split('x')
        return Rect(float(x), float(y), float(w), float(h))


class Vector:
    def __init__(self, dx, dy):
        self.dx = dx
        self.dy = dy

    def __eq__(self, other: Optional['Vector']) -> bool:
        if not other:
            return False
        return self.dx == other.dx and self.dy == other.dy

    def __repr__(self):
        return f'(dx: {self.dx}, dy: {self.dy})'

    @property
    def radians(self):
        rad = math.atan2(self.dy, self.dx)
        return rad if rad >= 0 else rad + 2 * math.pi

    @classmethod
    def from_radians(self, radians):
        rad = math.pi - radians if radians > math.pi else radians
        return self(math.cos(rad), math.sin(rad))

    @classmethod
    def from_degrees(self, degrees):
        return self.from_radians(degrees_to_radians(degrees))

    @classmethod
    def zero(self):
        return Vector(0, 0)


def degrees_to_radians(degrees):
    if degrees == 0:
        return 0
    if degrees < 0:
        return degrees_to_radians(degrees + 360)
    if degrees >= 360:
        return degrees_to_radians(degrees - 360)
    return degrees * math.pi / 180
