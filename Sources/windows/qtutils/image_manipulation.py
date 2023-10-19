import math
from PyQt6.QtGui import QPixmap, QPainter, QTransform


def _rotated_pixmap(pixmap: QPixmap, angle: float) -> QPixmap:
    painter = QPainter(pixmap)
    painter.translate(pixmap.width() / 2, pixmap.height() / 2)
    painter.rotate(angle * 180 / math.pi)
    painter.translate(-pixmap.width() / 2, -pixmap.height() / 2)
    transform = QTransform()
    transform.rotateRadians(angle)
    return pixmap.transformed(transform)


QPixmap.rotated = _rotated_pixmap


def _flipped_pixmap(pixmap: QPixmap, **kwargs) -> QPixmap:
    transform = QTransform()
    if kwargs.get('horizontally'):
        transform = transform.scale(-1, 1)
    if kwargs.get('vertically'):
        transform = transform.scale(1, -1)
    return pixmap.transformed(transform)


QPixmap.flipped = _flipped_pixmap
