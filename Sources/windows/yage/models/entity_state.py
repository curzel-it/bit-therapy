from enum import Enum


class EntityState(Enum):
    FREE_FALL = 'free_fall'
    DRAG = 'drag'
    MOVE = 'move'
    ANIMATION = 'animation'

    def __repr__(self):
        return self.value
