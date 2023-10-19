import unittest

from yage.capabilities import AutoRespawn
from yage.models.entity import Entity
from yage.utils.geometry import Point, Rect
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class AutoRespawnTests(unittest.TestCase):
    def setUp(self):
        self.entity = Entity(
            SPECIES_AGENT,
            "test",
            Rect(0, 0, 1, 1),
            World('', Rect(0, 0, 10, 10))
        )
        self.respawner = self.entity.install(AutoRespawn)
        self.respawner.kill()
        self.respawner.subject = self.entity

    def test_entity_inside_bounds_is_untouched(self):
        for y in range(10):
            point = Point(0, y)
            self.assertTrue(self.respawner.is_within_bounds(point))

    def test_entity_outside_bounds_is_detected(self):
        self.assertFalse(self.respawner.is_within_bounds(Point(-251, 0)))
        self.assertFalse(self.respawner.is_within_bounds(Point(260, 0)))
        self.assertFalse(self.respawner.is_within_bounds(Point(0, -251)))
        self.assertFalse(self.respawner.is_within_bounds(Point(0, 260)))
