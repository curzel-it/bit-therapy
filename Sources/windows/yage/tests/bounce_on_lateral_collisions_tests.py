import math
import unittest
from yage.capabilities import BounceOnLateralCollisions, LinearMovement
from yage.models.entity import Entity
from yage.utils.geometry import Point, Rect, Vector
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class BounceOnLateralCollisionsTests(unittest.TestCase):
    def setUp(self):
        self.test_env = World("test", Rect(0, 0, 100, 100))
        self.test_entity = Entity(
            SPECIES_AGENT,
            "entity",
            Rect(50, 0, 10, 10),
            self.test_env
        )
        self.bounce = self.test_entity.install(BounceOnLateralCollisions)
        self.movement = self.test_entity.install(LinearMovement)
        self.test_env.children.append(self.test_entity)

    def test_non_static_entities_are_ignored(self):
        self.test_entity.frame.origin = Point(50, 0)
        self.test_entity.direction = Vector(1, 0)
        test_right = Entity(
            SPECIES_AGENT,
            "right",
            Rect(self.test_entity.frame.max_x - 5, 0, 50, 50),
            self.test_env
        )
        self.test_env.children.append(test_right)

        collisions = self.test_entity.collisions([test_right])
        angle = self.bounce.bouncing_angle(0, collisions)
        self.assertEqual(angle, None)

        self.test_entity.update(collisions, 0.01)
        self.assertAlmostEqual(self.test_entity.direction.dx, 1, delta=0.00001)
        self.assertAlmostEqual(self.test_entity.direction.dy, 0, delta=0.00001)

    def test_bounces_to_left_when_hitting_right(self):
        self.test_entity.frame.origin = Point(50, 0)
        self.test_entity.direction = Vector(1, 0)
        test_right = Entity(
            SPECIES_AGENT,
            "right",
            Rect(self.test_entity.frame.max_x - 5, 0, 50, 50),
            self.test_env
        )
        test_right.is_static = True
        self.test_env.children.append(test_right)

        collisions = self.test_entity.collisions([test_right])
        angle = self.bounce.bouncing_angle(0, collisions)
        self.assertEqual(angle, math.pi)

        self.test_entity.update(collisions, 0.01)
        self.assertAlmostEqual(
            self.test_entity.direction.dx, -1, delta=0.00001)
        self.assertAlmostEqual(self.test_entity.direction.dy, 0, delta=0.00001)

    def test_bounces_to_right_when_hitting_left(self):
        self.test_entity.frame.origin = Point(50, 0)
        self.test_entity.direction = Vector(-1, 0)
        test_left = Entity(
            SPECIES_AGENT,
            "left",
            Rect(self.test_entity.frame.min_x - 50 + 5, 0, 50, 50),
            self.test_env
        )
        test_left.is_static = True
        self.test_env.children.append(test_left)

        collisions = self.test_entity.collisions([test_left])
        angle = self.bounce.bouncing_angle(math.pi, collisions)
        self.assertEqual(angle, 0)

        self.test_entity.update(collisions, 0.01)
        self.assertAlmostEqual(self.test_entity.direction.dx, 1, delta=0.00001)
        self.assertAlmostEqual(self.test_entity.direction.dy, 0, delta=0.00001)
