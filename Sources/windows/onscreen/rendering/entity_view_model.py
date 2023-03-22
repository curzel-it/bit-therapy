from functools import cached_property
from typing import Optional, Tuple
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QPixmap
from rx.subject import BehaviorSubject
from di.di import Dependencies
from onscreen.rendering.coordinate_system import CoordinateSystem
from onscreen.rendering.image_interpolation import ImageInterpolationMode, ImageInterpolationUseCase
from qtutils.screens import Screens
from yage.capabilities.draggable import Draggable
from yage.models.assets import AssetsProvider
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point, Size, Rect


class EntityViewModel:
    def __init__(self, entity: Entity):
        self.tag = f'ViewModel-{entity.id}'
        self._assets = Dependencies.instance(AssetsProvider)
        self._coordinate_system = Dependencies.instance(CoordinateSystem)
        self._image_interpolation = Dependencies.instance(ImageInterpolationUseCase)
        screen = Dependencies.instance(Screens).main
        self._scale_factor = screen.scale_factor
        self._screen_size = screen.size
        self._entity = entity
        self._first_mouse_click = None
        self._image_cache = {}
        self._interpolation_mode = ImageInterpolationMode.NONE
        self._is_mouse_down = False
        self._location_on_last_drag = Point.zero()
        self._location_on_mouse_down = Point.zero()
        self._last_sprite_hash = 0
        self.frame = BehaviorSubject(Rect(0, 0, 1, 1))
        self.is_alive = BehaviorSubject(entity.is_alive)
        self.image = BehaviorSubject(None)
        self._update_frame()

    @property
    def entity_id(self): 
        return self._entity.id

    @property
    def is_interactable(self): 
        return not self._entity.is_ephemeral

    def update(self):
        self.is_alive.on_next(self._entity.is_alive)
        if not self._entity.is_alive:
            return
        self._update_frame_if_needed()
        self._update_image_if_needed()

    def _update_frame_if_needed(self):
        if self._entity.state == EntityState.DRAG:
            return
        self._update_frame()

    def _update_frame(self):
        new_frame = self._coordinate_system.frame(self._entity)
        self.frame.on_next(new_frame)

    def _update_image_if_needed(self):
        image_hash = self._sprite_hash(self._entity)
        if not self._needs_sprite_update(image_hash):
            return
        self.image.on_next(self._next_image(image_hash))

    def mouse_down(self):
        if not self._is_draggable:
            return
        if self._is_mouse_down:
            return
        self._is_mouse_down = True
        self._location_on_last_drag = self.frame.value.origin
        self._location_on_mouse_down = self.frame.value.origin

    def dragged_to(self, final_destination: Point) -> bool:
        delta = Size(
            final_destination.x - self._location_on_last_drag.x - self.frame.value.width / 2,
            final_destination.y - self._location_on_last_drag.y - self.frame.value.height / 2
        )
        self.dragged_by(delta)

    def dragged_by(self, delta: Size) -> bool:
        if not self._is_draggable:
            return
        new_origin = self._location_on_last_drag.offset(size=delta)
        self.frame.on_next(Rect(new_origin, self.frame.value.size))
        self._location_on_last_drag = new_origin
        self._entity.drag.dragged(delta)

    def drag_ended(self):
        if not self._is_draggable:
            return
        if not self._is_mouse_down:
            return
        self._is_mouse_down = False
        delta = Size(
            self._location_on_last_drag.x - self._location_on_mouse_down.x,
            self._location_on_mouse_down.y - self._location_on_last_drag.y
        )
        self._entity.drag.drag_ended(delta)

    def right_mouse_up(self):
        pass

    @cached_property
    def _is_draggable(self):
        return self._entity.capability(Draggable) is not None

    def _next_image(self, image_hash: int) -> Optional[QPixmap]:
        if cached := self._image_cache.get(image_hash):
            return cached
        image = self._interpolated_image_for_current_sprite()
        if not image:
            return None
        self._image_cache[image_hash] = image
        return image

    def _interpolated_image_for_current_sprite(self) -> Optional[QPixmap]:
        asset = self._assets.image(self._entity.sprite)
        if not asset:
            return None
        interpolation = self._image_interpolation.interpolation_mode(asset, self.frame.value.size)
        transformation = self._image_interpolation.transformation_mode(interpolation)
        hflip, vflip, z_angle = self._rotations(self._entity)
        # Seems necessary on windows:
        # image_size = self.frame.value.size.scaled(self._scale_factor).as_qsize()
        image_size = self.frame.value.size.as_qsize()

        return asset \
            .scaled(image_size, Qt.AspectRatioMode.KeepAspectRatio, transformation) \
            .flipped(horizontally=hflip, vertically=vflip) \
            .rotated(z_angle)

    def _rotations(self, entity: Entity) -> Tuple[bool, bool, float]:
        horizontally, vertically, z_angle = False, False, 0
        try:
            horizontally = entity.rotation.is_flipped_horizontally
            vertically = entity.rotation.is_flipped_vertically
            z_angle = entity.rotation.z_angle
        except AttributeError:
            pass
        return horizontally, vertically, z_angle

    def _needs_sprite_update(self, new_hash: int) -> bool:
        if new_hash != self._last_sprite_hash:
            self._last_sprite_hash = new_hash
            return True
        return False

    def _sprite_hash(self, entity: Entity) -> int:
        hasher = hash(entity.sprite)
        hasher ^= hash(entity.frame.width)
        hasher ^= hash(entity.frame.height)
        hasher ^= hash(self._rotations(entity))
        return hasher
