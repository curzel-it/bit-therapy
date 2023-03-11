from typing import Tuple
from PyQt6.QtWidgets import QWidget, QLabel, QScrollArea, QVBoxLayout

def _with_margins(widget, **kwargs):
    current_margins = widget.contentsMargins()
    widget.setContentsMargins(
        kwargs.get('left') or current_margins.left(),
        kwargs.get('top') or current_margins.top(),
        kwargs.get('right') or current_margins.right(),
        kwargs.get('bottom') or current_margins.bottom()
    )
    return widget

QLabel.withMargins = _with_margins
QWidget.withMargins = _with_margins