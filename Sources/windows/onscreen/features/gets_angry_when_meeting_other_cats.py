from datetime import datetime, timedelta
from typing import List
from yage.models.animations import EntityAnimation
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.utils.logger import Logger


class GetsAngryWhenMeetingOtherCats(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.unlock_date = None

    def update(self, collisions, time):
        if self.unlock_date and self.unlock_date > datetime.now():
            return
        self.unlock_date = None
        self.do_update(collisions, time)

    def do_update(self, collisions, time):
        if self.subject.state != EntityState.MOVE:
            return
        if not self.is_touching_another_cat(according_to=collisions):
            return
        self.get_angry()

    def get_angry(self):
        Logger.log(self.tag, "Getting angry!")
        self.subject.animations_scheduler.load_animation(
            EntityAnimation("angry"),
            4
        )
        self.unlock_date = datetime.now() + timedelta(seconds=30)

    def is_touching_another_cat(self, according_to: List[Collision]) -> bool:
        for collision in according_to:
            if collision.other.species.id.startswith("cat"):
                return True
        return False
