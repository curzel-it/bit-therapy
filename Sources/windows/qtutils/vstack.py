from PyQt6.QtWidgets import QVBoxLayout


def vertically_stacked(*widgets, **kwargs):
    layout = QVBoxLayout()
    layout.setContentsMargins(0, 0, 0, 0)
    if spacing := kwargs.get('spacing'):
        layout.setSpacing(spacing)
    for widget in widgets:
        layout.addWidget(widget)
    return layout
