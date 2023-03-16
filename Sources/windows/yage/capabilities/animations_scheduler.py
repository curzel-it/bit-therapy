from datetime import datetime, timedelta
import random
from yage.models.animations import EntityAnimation
from yage.models.capability import Capability
from yage.models.entity_state import EntityState
from yage.utils.logger import Logger


class AnimationsScheduler(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        subject.animations_scheduler = self
        self._scheduled_animation = None

    def animate_now(self):
        animation = self._random_animation()
        if not animation:
            return
        loops = animation.required_loops or 1
        self._schedule(animation, loops, 0)
        Logger.log(self.tag, "Immediate animation requested", animation, f"x{loops}")

    def load_animation(self, animation: EntityAnimation, times: int):
        if not self.is_enabled:
            return
        if not self.subject.is_alive:
            return
        if self.subject.state != EntityState.MOVE:
            return
        self.subject.set_animation(animation, times)

    def do_update(self, collisions, time):
        if self._scheduled_animation is not None:
            self._apply_scheduled_sprite_if_possible()
        else:
            self._schedule_animation_after_random_interval()

    def _schedule_animation_after_random_interval(self):
        animation = self._random_animation()
        if not animation:
            return
        delay = random.uniform(10, 30)
        loops = animation.required_loops or 1
        self._schedule(animation, loops, delay)
        Logger.log(self.tag, "Scheduled", animation, f"x{loops} in {delay}")

    def _random_animation(self):
        try:
            return self.subject.animations_provider.random_animation()
        except TypeError:
            Logger.log(self.tag, "Could not load any animation...")
            return None

    def _schedule(self, animation: EntityAnimation, times: int, delay: float):
        next_date = datetime.now() + timedelta(seconds=delay)
        self._scheduled_animation = (animation, times, next_date)

    def _apply_scheduled_sprite_if_possible(self):
        animation, times, date = self._scheduled_animation
        if date > datetime.now():
            return
        self._scheduled_animation = None
        self.load_animation(animation, times)
