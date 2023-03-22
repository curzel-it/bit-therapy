from enum import Enum
from typing import Optional
from yage.utils.geometry import Point, Rect, Size, Vector


class EntityAnimationPosition(Enum):
    FROM_ENTITY_BOTTOM_LEFT = 'fromEntityBottomLeft'
    ENTITY_TOP_LEFT = 'entityTopLeft'
    WORLD_TOP_LEFT = 'worldTopLeft'
    WORLD_BOTTOM_LEFT = 'worldBottomLeft'
    WORLD_TOP_RIGHT = 'worldTopRight'
    WORLD_BOTTOM_RIGHT = 'worldBottomRight'


class EntityAnimation:
    def __init__(
        self,
        animation_id: str,
        size: Optional[Size] = None,
        position: 'EntityAnimationPosition' = EntityAnimationPosition.FROM_ENTITY_BOTTOM_LEFT,
        facing_direction: Optional[Vector] = None,
        required_loops: Optional[int] = None
    ):
        self.id = animation_id
        self.size = size
        self.position = position
        self.facing_direction = facing_direction
        self.required_loops = required_loops

    def frame(self, entity) -> Rect:
        new_size = self._size(entity.frame.size)
        new_position = self._position(entity.frame, new_size, entity.world_bounds)
        return Rect(new_position.x, new_position.y, new_size.width, new_size.height)

    def _size(self, original_size):
        if self.size is None:
            return original_size
        return Size(
            width=self.size.width * original_size.width,
            height=self.size.height * original_size.height
        )

    def _position(self, entity_frame, new_size, world_bounds) -> 'Point':
        if self.position == EntityAnimationPosition.FROM_ENTITY_BOTTOM_LEFT:
            return entity_frame.origin.offset(y=entity_frame.size.height - new_size.height)
        elif self.position == EntityAnimationPosition.ENTITY_TOP_LEFT:
            return entity_frame.origin
        elif self.position == EntityAnimationPosition.WORLD_TOP_LEFT:
            return world_bounds.top_left
        elif self.position == EntityAnimationPosition.WORLD_BOTTOM_LEFT:
            return world_bounds.bottom_left.offset(y=-entity_frame.height)
        elif self.position == EntityAnimationPosition.WORLD_TOP_RIGHT:
            return world_bounds.top_right.offset(x=-entity_frame.width)
        elif self.position == EntityAnimationPosition.WORLD_BOTTOM_RIGHT:
            return world_bounds.bottom_right.offset(x=-entity_frame.size.width, y=-entity_frame.size.height)
        else:
            return Point.zero()

    def with_loops(self, loops: int) -> 'EntityAnimation':
        return EntityAnimation(
            animation_id=self.id,
            size=self.size,
            position=self.position,
            facing_direction=self.facing_direction,
            required_loops=loops
        )

    def __repr__(self):
        return self.id
