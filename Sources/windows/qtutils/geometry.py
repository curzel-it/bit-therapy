from PyQt6.QtCore import QSize, QPoint, QRect
from yage.utils.geometry import Size, Point, Rect

Point.as_qpoint = lambda value: QPoint(int(value.x), int(value.y))
QPoint.as_point = lambda value: Point(float(value.x()), float(value.y()))

Rect.as_qrect = lambda value: QRect(int(value.min_x), int(
    value.min_y), int(value.width), int(value.height))
Rect.as_rect = lambda value: Rect(float(value.x()), float(
    value.y()), float(value.width()), float(value.height()))

Size.as_qsize = lambda value: QSize(int(value.width), int(value.height))
Size.as_size = lambda value: Size(float(value.width()), float(value.height()))
