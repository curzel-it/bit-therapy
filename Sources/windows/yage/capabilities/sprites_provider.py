from typing import List
from yage.models import Capability, EntityState


class SpritesProvider(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        subject.sprites_provider = self

    def sprite(self, state: EntityState) -> str:
        raise NotImplementedError()

    def frames(self, state: EntityState) -> List[str]:
        raise NotImplementedError()
