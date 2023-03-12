from typing import Tuple
from PyQt6.QtWidgets import QWidget, QLabel, QScrollArea, QVBoxLayout

from qtutils.sizing import Spacing, pixels

def _with_margins(widget, **kwargs):
    current_margins = widget.contentsMargins()

    def arg(key):
        return pixels(kwargs.get(key))

    widget.setContentsMargins(
        arg('left') or current_margins.left(),
        arg('top') or current_margins.top(),
        arg('right') or current_margins.right(),
        arg('bottom') or current_margins.bottom()
    )
    return widget

QLabel.withMargins = _with_margins
QWidget.withMargins = _with_margins