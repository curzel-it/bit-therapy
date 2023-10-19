from datetime import datetime
from typing import Any, List, Optional, Tuple
from di import Dependencies
from yage.models.animations import EntityAnimation
from yage.models.capability import CapabilitiesDiscoveryService
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.utils.geometry import Vector
from yage.utils.logger import Logger


class Entity:
    def __init__(self, species, entity_id: str, frame, world):
        self._animation = None
        self._animation_loops = None
        self.capabilities = []
        self.creation_date = datetime.now()
        self.direction = Vector.zero()
        self.fps = species.fps
        self.frame = frame
        self.id = entity_id
        self.is_alive = True
        self.is_ephemeral = False
        self.is_static = False
        self.species = species
        self.speed = 0
        self.sprite = None
        self.state = EntityState.MOVE
        self.world = world
        self.z_index = 0
        self._install_capabilities()

    @property
    def world_bounds(self):
        return self.world.bounds

    def animation(self) -> Tuple['EntityAnimation', int]:
        if self.state != EntityState.ANIMATION:
            return (None, None)
        return (self._animation, self._animation_loops)

    def set_animation(self, animation: 'EntityAnimation', loops: int):
        self._animation = animation
        self._animation_loops = loops
        self.state = EntityState.ANIMATION

    def collisions(self, neighbors: List['Entity']) -> List['Collision']:
        valid_neighbors = [n for n in neighbors if n != self]
        collisions = [self.collision(n) for n in valid_neighbors]
        collisions = [c for c in collisions if c is not None]
        return collisions

    def collision(self, other: 'Entity') -> Optional['Collision']:
        intersection = self.frame.intersection(other.frame)
        if not intersection:
            return None
        return Collision(self, other, intersection)

    def __setattr__(self, name: str, value: Any) -> None:
        super().__setattr__(name, value)
        if name == 'state':
            Logger.log(self.id, 'State changed to', self.state)
            if self.state == EntityState.MOVE:
                self.reset_speed()

    def _install_capabilities(self):
        for capability_id in self.species.capabilities:
            capability = Dependencies.instance(
                CapabilitiesDiscoveryService).capability(capability_id)
            if capability is not None:
                self.install(capability)

    def reset_speed(self):
        self.speed = 1

    def install(self, capability_type):
        capability = capability_type(self)
        self.capabilities.append(capability)
        return capability

    def capability(self, some_type):
        for capability in self.capabilities:
            if isinstance(capability, some_type):
                return capability
        return None

    def update(self, collisions, time):
        if not self.is_alive:
            return
        for capability in self.capabilities:
            capability.update(collisions, time)

    def kill(self):
        self._uninstall_all_capabilities()
        self.is_alive = False
        self.sprite = None

    def _uninstall_all_capabilities(self):
        for capability in self.capabilities:
            capability.kill(False)
        self.capabilities = []

    def __repr__(self):
        return self.id

    def __eq__(self, other):
        return self.id == other.id
