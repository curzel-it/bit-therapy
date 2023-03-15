from datetime import datetime, timedelta
import random
from typing import List, Optional
from yage.capabilities import AnimationsScheduler, BounceOnLateralCollisions, Gravity, LinearMovement, Seeker, SeekerState, SeekerTargetPosition
from yage.models.capability import Capability
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.utils.geometry import Vector
from yage.utils.logger import Logger


class JumpingPlatformsProvider:
    def __init__(self):
        self.platforms: List[Entity] = []


class RandomPlatformJumper(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        subject.platform_jumper = self
        self._scheduled_jump_date = None
        self._last_platform_id = None
        self._was_gravity_enabled = True
        self.platforms_provider = JumpingPlatformsProvider()

    def do_update(self, collisions, time):
        if self._scheduled_jump_date:
            if self._scheduled_jump_date < datetime.now():
                self._scheduled_jump_date = None
                self._find_platform_and_jump()
        else:
            self._schedule_jump_after_random_interval()

    def _schedule_jump_after_random_interval(self):
        delay = random.uniform(30, 120)
        self._scheduled_jump_date = datetime.now() + timedelta(seconds=delay)
        Logger.log(self.tag, f"Scheduled jump in {delay}")

    def _find_platform_and_jump(self):
        if not self.is_enabled or not self.subject.is_alive:
            return
        if target := self._find_platform():
            self._jump_to_target(target)
            self.is_enabled = False
        else:
            Logger.log(self.tag, "Can't jump, no platform found")

    def _jump_to_target(self, target: Entity):
        Logger.log(self.tag, "Jumping to", target.id, target.frame)
        self._last_platform_id = target.id
        self._prepare_subject_for_travel()

        seeker = self.subject.install(Seeker)
        seeker.follow(
            target,
            position=SeekerTargetPosition.ABOVE,
            auto_adjust_speed=False,
            on_update=self._on_seeker_update
        )

    def _prepare_subject_for_travel(self):
        if animations := self.subject.capability(AnimationsScheduler):
            animations.is_enabled = False
        if bounce := self.subject.capability(BounceOnLateralCollisions):
            bounce.is_enabled = False
        if movement := self.subject.capability(LinearMovement):
            movement.is_enabled = True
        if gravity := self.subject.capability(Gravity):
            self._was_gravity_enabled = gravity.is_enabled
            gravity.is_enabled = False
        self.subject.reset_speed()

    def _find_platform(self) -> Optional[Entity]:
        platforms = [
            p for p in self.platforms_provider.platforms if p.id != self._last_platform_id]
        if len(platforms) > 0:
            return random.choice(platforms)
        return None

    def _on_seeker_update(self, state: EntityState, _: float):
        if state not in [SeekerState.CAPTURED, SeekerState.LOST]:
            return
        Logger.log(self.tag, "Target reached.")
        self._restore_initial_conditions()

    def _restore_initial_conditions(self):
        if seeker := self.subject.capability(Seeker):
            seeker.kill()
        if bounce := self.subject.capability(BounceOnLateralCollisions):
            bounce.is_enabled = True
        if gravity := self.subject.capability(Gravity):
            gravity.is_enabled = self._was_gravity_enabled
        if animations := self.subject.capability(AnimationsScheduler):
            animations.is_enabled = True
        if movement := self.subject.capability(LinearMovement):
            movement.is_enabled = True
        self.subject.direction = Vector(1, 0)
        self.subject.state = EntityState.MOVE
        self.subject.reset_speed()
        self.is_enabled = True

    def kill(self, autoremove=True):
        self.platforms_provider = JumpingPlatformsProvider()
        self.subject.platform_jumper = None
        self._restore_initial_conditions()
        super().kill(autoremove)
