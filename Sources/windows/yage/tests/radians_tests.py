import math
import unittest
from yage.utils.geometry import Vector, degrees_to_radians


class RadiansTests(unittest.TestCase):
    def test_correct_radians_from_vector(self):
        self.assertAlmostEqual(Vector(dx=0, dy=0).radians, math.pi * 0.0)
        self.assertAlmostEqual(Vector(1, 0).radians, math.pi * 0.0)
        self.assertAlmostEqual(Vector(dx=0, dy=1).radians, math.pi * 0.5)
        self.assertAlmostEqual(Vector(dx=-1, dy=0).radians, math.pi * 1.0)
        self.assertAlmostEqual(Vector(dx=0, dy=-1).radians, math.pi * 1.5)

    def test_correct_vector_from_radians(self):
        self.assertAlmostEqual(math.pi * 0.0, Vector(dx=0, dy=0).radians)
        self.assertAlmostEqual(math.pi * 0.0, Vector(1, 0).radians)
        self.assertAlmostEqual(math.pi * 0.5, Vector(dx=0, dy=1).radians)
        self.assertAlmostEqual(math.pi * 1.0, Vector(dx=-1, dy=0).radians)
        self.assertAlmostEqual(math.pi * 1.5, Vector(dx=0, dy=-1).radians)

    def test_can_convert_degrees_to_radians(self):
        self.assertAlmostEqual(degrees_to_radians(0), 0, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(
            90), math.pi * 0.5, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(
            180), math.pi * 1.0, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(0), 0, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(
            90), math.pi * 0.5, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(
            180), math.pi * 1.0, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(
            270), math.pi * 1.5, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(360), 0, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(720), 0, delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(-123),
                               degrees_to_radians(360 - 123), delta=0.0001)
        self.assertAlmostEqual(degrees_to_radians(
            360 + 123), degrees_to_radians(123), delta=0.0001)
