import unittest
from yage.capabilities import WallCrawler
from yage.capabilities.linear_movement import LinearMovement
from yage.capabilities.rotating import Rotating
from yage.models.entity import Entity
from yage.utils.geometry import Rect, Vector
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class WallCrawlerTests(unittest.TestCase):
    def test_will_crawl_along_screen(self):
        world = World('', Rect(x=0, y=0, width=10, height=10))
        entity = Entity(
            species=SPECIES_AGENT,
            entity_id="entity",
            frame=Rect(x=0, y=9, width=1, height=1),
            world=world
        )
        entity.install(Rotating)
        entity.install(LinearMovement)
        entity.install(WallCrawler)
        entity.direction = Vector(1, 0)

        for _ in range(0, 100):
            entity.update([], 0.1)
        self.assertEqual(Vector(0, -1), entity.direction)

        for _ in range(0, 100):
            entity.update([], 0.1)
        self.assertEqual(Vector(-1, 0), entity.direction)

        for _ in range(0, 100):
            entity.update([], 0.1)
        self.assertEqual(Vector(0, 1), entity.direction)

        for _ in range(0, 100):
            entity.update([], 0.1)
        self.assertEqual(Vector(1, 0), entity.direction)
