from enum import Enum
from yage.models.entity import Entity
from yage.models.species import SPECIES_HOTSPOT
from yage.utils.geometry import Rect

BOUNDS_THICKNESS = 2

class Hotspot(Enum):
    top_bound = 'top_bound'
    left_bound = 'left_bound'
    right_bound = 'right_bound'
    bottom_bound = 'bottom_bound'

    def build_bottom_bound(world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.bottom_bound.value,
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

    def build_top_bound(world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.top_bound.value,
            Rect(0, 0, world.bounds.width, BOUNDS_THICKNESS),
            world
        )
        entity.is_static = True
        return entity

    def build_left_bound(world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.left_bound.value,
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

    def build_right_bound(world) -> Entity:
        entity = Entity(
            SPECIES_HOTSPOT,
            Hotspot.right_bound.value,
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
