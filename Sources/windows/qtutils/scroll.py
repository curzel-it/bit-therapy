from typing import Tuple
from PyQt6.QtWidgets import QWidget, QScrollArea, QVBoxLayout

def _set_scrollable_to_widget(widget, layout):
    scroll_area, scroll_layout = _as_scrollable(layout)
    widget.setLayout(scroll_layout)
    widget.layout().addWidget(scroll_area)

def _as_scrollable(layout: QVBoxLayout) -> Tuple[QScrollArea, QVBoxLayout]:
    scroll_area = QScrollArea()
    scroll_area.setWidgetResizable(True)
    container = QWidget()
    container.setLayout(layout)
    scroll_area.setWidget(container)
    scroll_layout = QVBoxLayout()
    scroll_layout.setContentsMargins(0, 0, 0, 0)
    return scroll_area, scroll_layout

QWidget.setScrollable = _set_scrollable_to_widget