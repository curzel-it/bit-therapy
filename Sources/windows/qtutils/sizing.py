import enum
import pdb
from typing import Tuple
from PyQt6.QtWidgets import QWidget, QLabel, QScrollArea, QVBoxLayout, QSizePolicy
from PyQt6.QtWidgets import QApplication

from di.di import Dependencies
from qtutils.screens import Screens

class Spacing(enum.Enum):
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

def pixels(object):
    value = object.value if object.__class__ == Spacing else object
    if value is None: return None    
    scale_factor = Dependencies.instance(Screens).main.scale_factor
    return int(value * scale_factor)

def _compact(widget):
    widget.setSizePolicy(
        QSizePolicy.Policy.MinimumExpanding, 
        QSizePolicy.Policy.MinimumExpanding
    )
    return widget

QWidget.compact = _compact