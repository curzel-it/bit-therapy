from datetime import datetime, timedelta
from typing import Optional
from yage.models.animations import EntityAnimation
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point, Size
from yage.utils.logger import Logger


class SleepingPlace(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.wake_up_date = None
        self._cached_without_sleep = {}
        subject.frame.size = Size(
            width=subject.frame.width * 2,
            height=subject.frame.height * 2
        )

    def update(self, collisions, time):
        self._wake_from_sleep_if_needed()
        if not self.is_enabled:
            return
        self.do_update(collisions, time)

    def do_update(self, collisions, time):
        if self.subject.state != EntityState.MOVE:
            return
        entity = self._overlapping_entity_that_can_sleep(collisions)
        if entity is None:
            return
        self._put_to_sleep(entity)
        self.is_enabled = False
        self.wake_up_date = datetime.now() + timedelta(seconds=120)

    def _wake_from_sleep_if_needed(self):
        if self.wake_up_date is None:
            return
        if self.wake_up_date > datetime.now():
            return
        Logger.log(self.tag, "Ready for use again")

        self.is_enabled = True
        self.wake_up_date = None

    def _put_to_sleep(self, entity):
        sleep = self._sleep_animation(entity)
        if sleep is None:
            return
        Logger.log(self.tag, "Putting", entity.id, "to sleep")

        entity.frame.origin = Point(
            x=self.subject.frame.center.x - entity.frame.width / 2,
            y=self.subject.frame.max_y - entity.frame.height
        )
        entity.animations_scheduler.load_animation(sleep, sleep.required_loops)

    def _overlapping_entity_that_can_sleep(self, collisions):
        collisions = [c for c in collisions if self._can_sleep(c)]
        collisions = sorted(
            collisions, key=lambda c: c.intersection.area(), reverse=True)
        if collisions and len(collisions) > 0:
            return collisions[0].other
        return None

    def _sleep_animation(self, entity) -> Optional[EntityAnimation]:
        if self._cached_without_sleep.get(entity.id):
            return None
        try:
            return [a for a in entity.species.animations if a.id == 'sleep'][0]
        except IndexError:
            Logger.log(self.tag, entity.id, "has not 'sleep' animation")
            self._cached_without_sleep[entity.id] = True
            return None

    def _can_sleep(self, collision: Collision) -> bool:
        if collision.intersection.area() < 100:
            return False
        return self._sleep_animation(collision.other)
