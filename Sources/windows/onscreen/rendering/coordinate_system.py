from yage.models.entity import Entity
from yage.utils.geometry import Rect


class CoordinateSystem:
    def frame(self, entity: Entity) -> Rect:
        raise NotImplementedError()


class QtCoordinateSystem:
    def frame(self, entity: Entity) -> Rect:
        return entity.frame
