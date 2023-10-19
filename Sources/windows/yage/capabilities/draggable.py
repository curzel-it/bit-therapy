from typing import Optional
from yage.models import Capability
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point, Rect, Size


class Draggable(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.subject.drag = self

    def dragged(self, current_delta: Size) -> None:
        if not self.drag_enabled:
            return
        if not self.is_being_dragged:
            self._drag_started()
        new_frame = self.subject.frame.offset(size=current_delta)
        self.subject.frame.origin = self._nearest_position(
            new_frame, self.subject.world_bounds)

    def drag_ended(self, _: Size) -> Optional[Point]:
        if not self.drag_enabled or not self.is_being_dragged:
            return None
        return self._drag_ended()

    @property
    def drag_enabled(self):
        return self.is_enabled and not self.subject.is_static

    @property
    def is_being_dragged(self):
        return self.subject.state == EntityState.DRAG

    def _drag_started(self) -> None:
        self.subject.state = EntityState.DRAG
        self.subject.movement.is_enabled = False

    def _drag_ended(self):
        self.subject.state = EntityState.MOVE
        self.subject.movement.is_enabled = True

    def _nearest_position(self, rect: Rect, bounds: Rect) -> Point:
        return Point(
            min(max(rect.min_x, 0), bounds.width - rect.width),
            min(max(rect.min_y, 0), bounds.height - rect.height)
        )
