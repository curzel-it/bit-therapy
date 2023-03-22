from datetime import datetime, timedelta
from typing import Callable
from config.config import Config
from di.di import Dependencies
from onscreen.models.pet_entity import PetEntity
from yage.capabilities.linear_movement import LinearMovement
from yage.capabilities.seeker import Seeker, SeekerState, SeekerTargetPosition
from yage.capabilities.shape_shifter import ShapeShifter
from yage.models.animations import EntityAnimation, EntityAnimationPosition
from yage.models.capability import Capability
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.models.species import Species
from yage.models.world import World
from yage.utils.geometry import Point, Size, Vector


class UfoAbductionUseCase:
    def __init__(self):
        self.settings = Dependencies.instance(Config)

    def start(self, target: Entity, world: World, completion: Callable[[], None]):
        ufo = self._build_ufo(world)
        abduction = ufo.capability(UfoAbduction)
        abduction.start(target, lambda: self._clean_up_after_abduction(
            target, ufo, world, completion))

    def _clean_up_after_abduction(self, target: Entity, ufo: Entity, world: World, completion: Callable[[], None]):
        ufo.kill()
        target.kill()
        world.children.remove(ufo)
        world.children.remove(target)
        completion()

    def _build_ufo(self, world: World) -> Entity:
        ufo = PetEntity(self._ufo_species(), world)
        ufo.frame.origin = world.bounds.top_left
        ufo.is_ephemeral = True
        ufo.install(UfoAbduction)
        world.children.append(ufo)
        return ufo

    def _ufo_species(self):
        return Species(
            id="ufo",
            capabilities=[
                "AnimatedSprite",
                "AnimationsProvider",
                "LinearMovement",
                "PetsSpritesProvider"
            ],
            drag_path="front",
            movement_path="front",
            speed=2
        )


class UfoAbduction(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self._target = None
        self._subject_original_size = None
        self._on_completion = lambda: None
        self._animation_completion_date = None

    def start(self, target: Entity, on_completion: callable):
        self._subject_original_size = target.frame.size()
        self._target = target
        self._on_completion = on_completion

        seeker = target.install(Seeker)
        distance = Point(0, -50)
        seeker.follow(
            target,
            position=SeekerTargetPosition.ABOVE,
            offset=distance,
            on_update=lambda s: self._on_capture(s, seeker)
        )

    def do_update(self, collisions, time):
        if self._animation_completion_date:
            if self._animation_completion_date < datetime.now():
                self._animation_completed()
        return super().do_update(collisions, time)

    def _on_capture(self, capture_state, seeker):
        if capture_state != SeekerState.CAPTURED:
            return
        seeker.is_enabled = False
        self._paralyze_target()
        self._capture_ray_animation()

    def _paralyze_target(self):
        self._target.set_gravity(enabled=False)
        self._target.direction = Point(0, -1)
        self._target.speed = 1.2 * \
            PetEntity.speed_multiplier(self._target.frame.width)

    def _capture_ray_animation(self):
        self.subject.direction = Vector.zero()
        abduction = EntityAnimation(
            id='abduction',
            size=Size(1, 3),
            position=EntityAnimationPosition.ENTITY_TOP_LEFT
        )
        self.subject.set_animation(abduction, loops=1)
        if seeker := self.subject.capability(Seeker):
            seeker.kill()

        shape = self._target.install(ShapeShifter)
        shape.scale_linearly(Size(5, 5), 1.1)
        self._animation_completion_date = datetime.now() + timedelta(seconds=1.25)

    def _animation_completed(self):
        self._animation_completion_date = None
        self._target.kill()
        self.subject.set_gravity(enabled=False)
        self.subject.direction = Vector(1, -1)
        self.subject.set_state(EntityState.MOVE)
        movement = self.subject.capability(LinearMovement)
        if movement:
            movement.is_enabled = True
        self.subject.frame.size = self._subject_original_size
        self._on_completion()
        self.kill()

    def kill(self, autoremove=True):
        self._target = None
        self._on_completion = lambda: None
        super().kill(autoremove)
