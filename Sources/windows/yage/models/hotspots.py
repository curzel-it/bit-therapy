from enum import Enum
from yage.models.entity import Entity
from yage.models.species import SPECIES_HOTSPOT
from yage.utils.geometry import Rect

BOUNDS_THICKNESS = 2


class Hotspot(Enum):
    TOP_BOUND = 'top_bound'
    LEFT_BOUND = 'left_bound'
    RIGHT_BOUND = 'right_bound'
    BOTTOM_BOUND = 'bottom_bound'

    @classmethod
    def build_bottom_bound(cls, world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.BOTTOM_BOUND.value,
            Rect(
                0,
                world.bounds.height,
                world.bounds.width,
                BOUNDS_THICKNESS
            ),
            world
        )
        entity.is_static = True
        return entity

    @classmethod
    def build_top_bound(cls, world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.TOP_BOUND.value,
            Rect(0, 0, world.bounds.width, BOUNDS_THICKNESS),
            world
        )
        entity.is_static = True
        return entity

    @classmethod
    def build_left_bound(cls, world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.LEFT_BOUND.value,
            Rect(
                0,
                0,
                BOUNDS_THICKNESS,
                world.bounds.height
            ),
            world
        )
        entity.is_static = True
        return entity

    @classmethod
    def build_right_bound(cls, world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.RIGHT_BOUND.value,
            Rect(
                world.bounds.width,
                0,
                BOUNDS_THICKNESS,
                world.bounds.height
            ),
            world
        )
        entity.is_static = True
        return entity
