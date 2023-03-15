import unittest
from yage.capabilities import ShapeShifter
from yage.models.entity import Entity
from yage.utils.geometry import Rect, Size
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class ShapeShifterTests(unittest.TestCase):
    def test_can_shrink(self):
        world = World('', Rect(x=0, y=0, width=1000, height=1000))
        entity = Entity(
            species=SPECIES_AGENT,
            entity_id="entity",
            frame=Rect(x=0, y=0, width=10, height=10),
            world=world
        )
        shape = entity.install(ShapeShifter)
        shape.scale_linearly(Size(1, 1), 1)

        for _ in range(0, 5):
            entity.update([], 0.1)
        self.assertAlmostEqual(entity.frame.size.width, 5.5, delta=0.1)
        self.assertAlmostEqual(entity.frame.size.height, 5.5, delta=0.1)

        for _ in range(0, 5):
            entity.update([], 0.1)
        self.assertAlmostEqual(entity.frame.size.width, 1, delta=0.1)
        self.assertAlmostEqual(entity.frame.size.height, 1, delta=0.1)

        entity.update([], 1)
        self.assertAlmostEqual(entity.frame.size.width, 1, delta=0.1)
        self.assertAlmostEqual(entity.frame.size.height, 1, delta=0.1)
