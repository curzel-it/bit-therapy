import unittest
from yage.utils.geometry import Rect
from yage.models.hotspots import Hotspot
from yage.models.world import World


class EnvironmentBoundsNoSafeAreaTests(unittest.TestCase):
    def setUp(self):
        self.env = World(name="test", bounds=Rect(
            x=0, y=50, width=400, height=900))

    def test_top_bound_properly_placed(self):
        bound = next((c for c in self.env.children if c.id ==
                     Hotspot.TOP_BOUND.value), None)
        self.assertIsNotNone(bound)
        self.assertEqual(bound.frame.min_x, 0)
        self.assertEqual(bound.frame.max_x, 400)
        self.assertEqual(bound.frame.min_y, 0)
        self.assertEqual(bound.frame.max_y, 2)

    def test_right_bound_properly_placed(self):
        bound = next((c for c in self.env.children if c.id ==
                     Hotspot.RIGHT_BOUND.value), None)
        self.assertIsNotNone(bound)
        self.assertEqual(bound.frame.min_x, 400)
        self.assertEqual(bound.frame.max_x, 402)
        self.assertEqual(bound.frame.min_y, 0)
        self.assertEqual(bound.frame.max_y, 900)

    def test_bottom_bound_properly_placed(self):
        bound = next((c for c in self.env.children if c.id ==
                     Hotspot.BOTTOM_BOUND.value), None)
        self.assertIsNotNone(bound)
        self.assertEqual(bound.frame.min_x, 0)
        self.assertEqual(bound.frame.max_x, 400)
        self.assertEqual(bound.frame.min_y, 900)
        self.assertEqual(bound.frame.max_y, 902)

    def test_left_bound_properly_placed(self):
        bound = next((c for c in self.env.children if c.id ==
                     Hotspot.LEFT_BOUND.value), None)
        self.assertIsNotNone(bound)
        self.assertEqual(bound.frame.min_x, 0)
        self.assertEqual(bound.frame.max_x, 2)
        self.assertEqual(bound.frame.min_y, 0)
        self.assertEqual(bound.frame.max_y, 900)
