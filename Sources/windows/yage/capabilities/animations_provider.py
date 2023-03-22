from random import choice
from yage.models.animations import EntityAnimation
from yage.models.capability import Capability


class AnimationsProvider(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.subject.animations_provider = self

    def random_animation(self) -> EntityAnimation:
        return choice(self.subject.species.animations)
