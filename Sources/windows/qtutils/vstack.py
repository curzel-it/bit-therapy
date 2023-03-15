from typing import Tuple
from PyQt6.QtWidgets import QWidget, QScrollArea, QVBoxLayout


def vertically_stacked(*widgets, **kwargs):
    layout = QVBoxLayout()
    layout.setContentsMargins(0, 0, 0, 0)
    if spacing := kwargs.get('spacing'):
        layout.setSpacing(spacing)
    for widget in widgets:
        layout.addWidget(widget)
    return layout
