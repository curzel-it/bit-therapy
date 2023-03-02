from typing import List
from config.assets import AssetsProvider
from yage.models import *
from yage.capabilities import SpritesProvider

class MySpritesProvider(SpritesProvider):
    def __init__(self, subject: Entity):
        super().__init__(subject)
        self.assets = AssetsProvider.shared

    def sprite(self, state: EntityState) -> str:
        if state == EntityState.FREE_FALL: return self.subject.species.drag_path
        elif state == EntityState.DRAG: return self.subject.species.drag_path
        elif state == EntityState.MOVE: return self.subject.species.movement_path
        else:
            animation = self.subject.animation()[0]
            if animation is None: return self.subject.species.movement_path
            return animation.id

    def frames(self, state: EntityState) -> List[str]:
        path = self.sprite(state)
        return self.assets.frames(species=self.subject.species.id, animation=path) or []