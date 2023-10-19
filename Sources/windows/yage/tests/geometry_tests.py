import unittest
from yage.utils.geometry import Point, Rect, Size


class GeometryTests(unittest.TestCase):
    def test_rect_from_geometry(self):
        self.assertEqual(Rect(1, 2, 3, 4), Rect.from_geometry("3x4+1+2"))
        self.assertEqual(Rect(1.1, 2.2, 3.3, 4.4),
                         Rect.from_geometry("3.3x4.4+1.1+2.2"))

    def test_rect_intersection_bottom_with_smaller_rect(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(2, 8, 5, 5)
        expected_intersection = Rect(2, 8, 5, 2)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_rect_intersection_bottom_with_larger_rect(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(-2, 8, 15, 5)
        expected_intersection = Rect(0, 8, 10, 2)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_rect_intersection_bottom_with_rect_of_equal_width(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(0, 8, 10, 5)
        expected_intersection = Rect(0, 8, 10, 2)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_rect_intersection_bottom_right(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(5, 5, 10, 10)
        expected_intersection = Rect(5, 5, 5, 5)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_rect_intersection_bottom_left(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(-5, 5, 10, 10)
        expected_intersection = Rect(0, 5, 5, 5)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_rect_intersection_top_left(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(-5, -5, 10, 10)
        expected_intersection = Rect(0, 0, 5, 5)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_rect_intersection_top_right(self):
        rect1 = Rect(0, 0, 10, 10)
        rect2 = Rect(5, -5, 10, 10)
        expected_intersection = Rect(5, 0, 5, 5)
        self.assertEqual(expected_intersection, rect1.intersection(rect2))

    def test_point_offset_x_y(self):
        self.assertEqual(Point(0, 0).offset(x=1), Point(1, 0))
        self.assertEqual(Point(0, 0).offset(y=0), Point(0, 1))
        self.assertEqual(Point(0, 0).offset(x=1, y=1), Point(1, 1))

    def test_point_offset_by_point(self):
        self.assertEqual(Point(0, 0).offset(point=Point(1, 0)), Point(1, 0))
        self.assertEqual(Point(0, 0).offset(point=Point(0, 1)), Point(0, 1))
        self.assertEqual(Point(0, 0).offset(point=Point(1, 1)), Point(1, 1))

    def test_point_offset_by_size(self):
        self.assertEqual(Point(0, 0).offset(size=Size(1, 0)), Point(1, 0))
        self.assertEqual(Point(0, 0).offset(size=Size(0, 1)), Point(0, 1))
        self.assertEqual(Point(0, 0).offset(size=Size(1, 1)), Point(1, 1))
