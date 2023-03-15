import unittest
from yage.capabilities import LinearMovement
from yage.models.entity import Entity
from yage.utils.geometry import Rect, Vector
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class LinearMovementTests(unittest.TestCase):
    def test_position_properly_updates(self):
        entity = Entity(
            species=SPECIES_AGENT,
            entity_id="entity",
            frame=Rect(x=0, y=0, width=1, height=1),
            world=World('', Rect(x=0, y=0, width=1000, height=1000))
        )
        entity.install(LinearMovement)
        entity.direction = Vector(1, 0)
        entity.speed = 1

        entity.update([], 0.1)
        self.assertAlmostEqual(entity.frame.origin.x, 0.1, delta=0.00001)
        self.assertAlmostEqual(entity.frame.origin.y, 0, delta=0.00001)

        entity.update([], 1)
        self.assertAlmostEqual(entity.frame.origin.x, 1.1, delta=0.00001)
        self.assertAlmostEqual(entity.frame.origin.y, 0, delta=0.00001)

        entity.update([], 10)
        self.assertAlmostEqual(entity.frame.origin.x, 11.1, delta=0.00001)
        self.assertAlmostEqual(entity.frame.origin.y, 0, delta=0.00001)
