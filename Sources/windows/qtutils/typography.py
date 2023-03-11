from typing import Tuple
from PyQt6.QtGui import QPixmap, QFont
from PyQt6.QtWidgets import QLabel, QScrollArea, QVBoxLayout

def _set_font_size(widget, size):
    font = widget.font()
    font.setPointSize(size)
    widget.setFont(font)
    return widget

def _make_front_bold(widget):
    font = widget.font()
    font = QFont.bold(font)
    widget.setFont(font)
    return widget

QLabel.withFontSize = _set_font_size
QLabel.bold = _make_front_bold