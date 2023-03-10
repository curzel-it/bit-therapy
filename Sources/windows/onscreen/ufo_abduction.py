from datetime import datetime, timedelta
from onscreen.pet_entity import PetEntity
from yage.capabilities.gravity import Gravity
from yage.capabilities.seeker import Seeker, SeekerState, SeekerTargetPosition
from yage.capabilities.shape_shifter import ShapeShifter
from yage.models.animations import EntityAnimation, EntityAnimationPosition
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.models.species import Species
from yage.utils.geometry import Point, Size, Vector
from yage.utils.logger import Logger

class UfoAbduction(PetEntity):
    def __init__(self, world):
        super().__init__(self._species(), world)
        Logger.log(self.id, "Created ufo...")
        self.frame.origin = Point(0, 0)
        self.is_ephemeral = True
        self._original_size = self.frame.size
        self._completion_date = None
        self._was_target_gravity_enabled = False
        self._kill_date = None

    @staticmethod
    def start(target: Entity):        
        ufo = UfoAbduction(target.world)
        target.world.children.append(ufo)
        ufo._abduct(target)

    def update(self, collisions, time):
        super().update(collisions, time)
        self._check_for_abduction_completion()
        self._check_for_event_completion()

    def _check_for_abduction_completion(self):
        if self._completion_date and self._completion_date < datetime.now():
            Logger.log(self.id, "Abduction completed", self.target.id)
            self._completion_date = None
            self._animation_completed()
    
    def _check_for_event_completion(self):
        if self._kill_date and self._kill_date < datetime.now():
            Logger.log(self.id, "All done!", self.target.id)
            self._kill_date = None
            self.kill()            

    def _abduct(self, target):
        Logger.log(self.id, "Started following", target.id)
        self.target = target
        self._original_target_size = target.frame.size
        seeker = self.capability(Seeker)
        seeker.follow(
            target,
            position=SeekerTargetPosition.ABOVE,
            offset=Point(0, -2.0*target.frame.height/3.0),
            auto_adjust_speed=False,
            on_update=self._on_seeker_update
        )

    def _on_seeker_update(self, status, distance):
        if status != SeekerState.CAPTURED: return
        Logger.log(self.id, "Captured", self.target.id)
        self.capability(Seeker).is_enabled = False
        self._paralize_target()
        self._capture_ray_animation()

    def _species(self) -> Species: 
        return Species(
            "ufo",
            [],
            [
                "AnimatedSprite",
                "AnimationsProvider",
                "LinearMovement",
                "PetsSpritesProvider",
                "Seeker"
            ],
            "front",
            10,
            "front",
            2,
            [],
            200
        )    

    def _paralize_target(self):
        Logger.log(self.id, "Paralized", self.target.id)
        if gravity := self.target.capability(Gravity): 
            self._was_target_gravity_enabled = gravity.is_enabled
            gravity.is_enabled = False
        self.target.direction = Vector(0, -1)
        self.target.reset_speed()
        self.target.speed = 1.2 * self.target.speed

    def _restore_target(self):
        Logger.log(self.id, "Restored", self.target.id)
        if gravity := self.target.capability(Gravity): 
            gravity.is_enabled = self._was_target_gravity_enabled
        self.target.direction = Vector(1, 0)
        self.target.frame.size = self._original_target_size
        self.target.place_in_random_position()

    def _capture_ray_animation(self):
        self.direction = Vector.zero()
        self.set_animation(self._abduction_animation(), 1)
        self.capability(Seeker).kill()
        shape = self.target.install(ShapeShifter)
        shape.scale_linearly(Size(1, 1), 1.1)
        self._schedule_completion(2.35)

    def _schedule_completion(self, delay):
        self._completion_date = datetime.now() + timedelta(seconds=delay)

    def _animation_completed(self):
        self.direction = Vector(1, -1)
        self.state = EntityState.MOVE
        self.movement.is_enabled = True
        self.frame.size = self._original_size
        self._kill_date = datetime.now() + timedelta(seconds=10)        

    def _abduction_animation(self):
        return EntityAnimation(
            'abduction', 
            Size(1, 3),
            EntityAnimationPosition.ENTITY_TOP_LEFT
        )

    def kill(self):
        self.world.children.remove(self)
        self._restore_target()
        self.target = None
        super().kill()