import math
import unittest
from yage.utils.geometry import Point, Rect


class PointsTests(unittest.TestCase):
    def test_angle_between_points_is_correct(self):
        o = Point.zero()
        self.assertAlmostEqual(o.angle_to(Point(x=0, y=0)), 0, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=1, y=1)), math.pi / 4, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=2, y=2)), math.pi / 4, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(Point(x=1, y=0)), 0, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=0, y=1)), math.pi / 2, delta=0.0001)

    def test_point_on_edge_of_rect_is_detected_properly(self):
        rect = Rect(x=0, y=0, width=1, height=1)
        self.assertTrue(Point(x=0, y=0).is_on_edge(rect))
        self.assertTrue(Point(x=0.5, y=1).is_on_edge(rect))
        self.assertTrue(Point(x=0, y=0.5).is_on_edge(rect))
        self.assertTrue(Point(x=0, y=1).is_on_edge(rect))
        self.assertTrue(Point(x=1, y=0).is_on_edge(rect))
        self.assertTrue(Point(x=1, y=1).is_on_edge(rect))
        self.assertFalse(Point(x=0.1, y=0.1).is_on_edge(rect))
        self.assertFalse(Point(x=0.5, y=0.5).is_on_edge(rect))

    def test_angle_to_other_point_is_correct(self):
        o = Point.zero()
        self.assertAlmostEqual(o.angle_to(Point(x=0, y=0)),
                               0.0 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(Point(x=1, y=0)),
                               0.0 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(Point(x=1, y=1)),
                               0.25 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(Point(x=0, y=1)),
                               0.5 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(Point(x=-1, y=1)),
                               0.75 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=-1, y=0)), 1.0 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=-1, y=-1)), 1.25 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=0, y=-1)), 1.5 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(Point(x=1, y=-1)),
                               1.75 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=0.9, y=0.9)), 0.25 * math.pi, delta=0.0001)
        self.assertAlmostEqual(o.angle_to(
            Point(x=0.9, y=-0.9)), 1.75 * math.pi, delta=0.0001)
