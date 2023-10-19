from typing import List
from config.assets import AssetsProvider
from di.di import Dependencies
from yage import SpritesProvider
from yage.models.entity_state import EntityState


class PetsSpritesProvider(SpritesProvider):
    def __init__(self, subject):
        super().__init__(subject)
        self.tag = 'PetsSpritesProvider'
        self.assets = Dependencies.instance(AssetsProvider)

    def sprite(self, state: EntityState) -> str:
        species = self.subject.species

        if state == EntityState.MOVE:
            return species.movement_path
        elif state == EntityState.DRAG:
            return species.drag_path
        elif state == EntityState.FREE_FALL:
            return species.drag_path
        else:
            animation, _ = self.subject.animation()
            return animation.id

    def frames(self, state: EntityState) -> List[str]:
        species = self.subject.species.id
        path = self.sprite(state)
        return self.assets.frames(species, path)
