import unittest
from yage.models.collisions import CollisionSide
from yage.models.entity import Entity
from yage.utils.geometry import Rect
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class CollisionsTests(unittest.TestCase):
    def setUp(self):
        self.test_bounds = Rect(0, 0, 100, 100)
        self.test_env = World("test", self.test_bounds)

    def test_multiple_collisions_can_be_detected(self):
        main = Entity(
            SPECIES_AGENT,
            "main",
            Rect(0, 0, 1, 1),
            self.test_env
        )

        def test_entity(index):
            return Entity(
                SPECIES_AGENT,
                f'other-{index}',
                Rect(0.1 * index, 0, 1, 1),
                self.test_env
            )
        others = [test_entity(i) for i in range(12)]
        collisions = main.collisions(others)
        self.assertEqual(len(collisions), 11)

        more_collisions = main.collisions([main] + others)
        self.assertEqual(len(more_collisions), 11)

    def test_distant_entities_do_not_collide(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(2, 2, 1, 1),
            self.test_env
        )
        collision = entity1.collision(entity2)
        self.assertIsNone(collision)

    def test_equal_entities_do_collide(self):
        entity = Entity(SPECIES_AGENT, "someEntity",
                        Rect(0, 0, 0, 0), self.test_env)
        collision = entity.collision(entity)
        self.assertIsNotNone(collision)

    def test_entities_with_same_frame_collide(self):

        entity1 = Entity(SPECIES_AGENT, "entity1",
                         Rect(0, 0, 0, 0), self.test_env)
        entity2 = Entity(SPECIES_AGENT, "entity2",
                         Rect(0, 0, 0, 0), self.test_env)
        collision = entity1.collision(entity2)
        self.assertIsNotNone(collision)

    def test_entities_sharing_one_corner_collide(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(1, 1, 1, 1),
            self.test_env
        )
        collision = entity1.collision(entity2)
        expected_intersection = Rect(1, 1, 0, 0)
        self.assertIsNotNone(collision)
        self.assertEqual(collision.intersection, expected_intersection)

    def test_entities_sharing_one_side_collide(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(1, 0, 1, 1),
            self.test_env
        )
        collision = entity1.collision(entity2)
        expected_intersection = Rect(1, 0, 0, 1)
        self.assertIsNotNone(collision)
        self.assertEqual(collision.intersection, expected_intersection)

    def test_overlapping_entities_collide(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 2, 2),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(1, 1, 2, 2),
            self.test_env
        )
        collision = entity1.collision(entity2)
        expected_intersection = Rect(1, 1, 1, 1)
        self.assertIsNotNone(collision)
        self.assertEqual(collision.intersection, expected_intersection)

    def test_overlapping_entities_collide(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 2, 2),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(1, 1, 2, 2),
            self.test_env
        )
        collision = entity1.collision(entity2)
        expected_intersection = Rect(1, 1, 1, 1)
        self.assertIsNotNone(collision)
        self.assertEqual(collision.intersection, expected_intersection)

    def test_collision_with_ephemeral_entities_are_properly_marked(self):
        entity1 = Entity(SPECIES_AGENT, "entity1", Rect.zero(), self.test_env)
        entity2 = Entity(SPECIES_AGENT, "entity2", Rect.zero(), self.test_env)
        entity2.is_ephemeral = True
        collision = entity1.collision(entity2)
        self.assertTrue(collision.is_ephemeral)

    def test_sides_detected_when_same_height_object_perfectly_collides_on_right(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(0.9, 0, 1, 1),
            self.test_env
        )
        collision = entity1.collision(entity2)
        sides = collision.sides()
        self.assertEqual(
            sides, [CollisionSide.TOP, CollisionSide.RIGHT, CollisionSide.BOTTOM])

    def test_sides_detected_when_smaller_collides_on_right(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(0.9, 0.25, 1, 0.5),
            self.test_env
        )
        collision = entity1.collision(entity2)
        sides = collision.sides()
        self.assertEqual(
            sides, [CollisionSide.TOP, CollisionSide.RIGHT, CollisionSide.BOTTOM])

    def test_sides_detected_when_larger_collides_on_right(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0.9, -1, 1, 3),
            self.test_env
        )
        collision = entity1.collision(entity2)
        sides = collision.sides()
        self.assertEqual(
            sides, [CollisionSide.TOP, CollisionSide.RIGHT, CollisionSide.BOTTOM])

    def test_sides_detected_when_object_collides_on_top_right(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(0.9, 0.9, 1, 1),
            self.test_env
        )
        collision = entity1.collision(entity2)
        sides = collision.sides()
        self.assertEqual(sides, [CollisionSide.TOP, CollisionSide.RIGHT])

    def test_sides_detected_when_object_collides_on_bottom_right(self):
        entity1 = Entity(
            SPECIES_AGENT,
            "entity1",
            Rect(0, 0, 1, 1),
            self.test_env
        )
        entity2 = Entity(
            SPECIES_AGENT,
            "entity2",
            Rect(0.9, -0.9, 1, 1),
            self.test_env
        )
        collision = entity1.collision(entity2)
        sides = collision.sides()
        self.assertEqual(sides, [CollisionSide.RIGHT, CollisionSide.BOTTOM])
