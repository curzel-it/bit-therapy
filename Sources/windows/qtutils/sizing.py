from enum import Enum
from PyQt6.QtWidgets import QWidget, QSizePolicy


class Spacing(Enum):
    XXXXL = 80
    XXXL = 64
    XXL = 48
    XL = 32
    LG = 24
    MD = 16
    SM = 8
    XS = 4
    ZERO = 0
    INVERSE_MD = -16


def _compact(widget):
    widget.setSizePolicy(
        QSizePolicy.Policy.MinimumExpanding,
        QSizePolicy.Policy.MinimumExpanding
    )
    return widget


QWidget.compact = _compact
