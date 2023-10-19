import unittest
from yage.capabilities import LinearMovement, Seeker, SeekerTargetPosition
from yage.models.entity import Entity
from yage.utils.geometry import Rect, Vector
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class SeekerTests(unittest.TestCase):
    def test_reaches_target(self):
        world = World('', Rect(x=0, y=0, width=1000, height=1000))
        entity = Entity(
            species=SPECIES_AGENT,
            entity_id="entity",
            frame=Rect(x=0, y=0, width=1, height=1),
            world=world
        )
        entity.install(LinearMovement)
        entity.direction = Vector(1, 0)
        entity.speed = 1

        target = Entity(
            species=SPECIES_AGENT,
            entity_id="target",
            frame=Rect(x=10, y=0, width=1, height=1),
            world=world
        )
        seeker = entity.install(Seeker)
        seeker.follow(target, position=SeekerTargetPosition.CENTER)

        entity.update([], 10)
        self.assertAlmostEqual(entity.frame.origin.x,
                               target.frame.origin.x, delta=0.00001)
        self.assertAlmostEqual(entity.frame.origin.y,
                               target.frame.origin.y, delta=0.00001)
