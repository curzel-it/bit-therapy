from PyQt6.QtWidgets import QWidget, QLabel

from qtutils.sizing import Spacing


def _with_margins(widget, **kwargs):
    current_margins = widget.contentsMargins()

    def arg(key):
        spacing = kwargs.get(key)
        if spacing is None:
            return None
        value = spacing.value if spacing.__class__ == Spacing else spacing
        return int(value)

    left = arg('left') or arg('horizontal') or current_margins.left()
    top = arg('top') or arg('vertical') or current_margins.top()
    right = arg('right') or arg('horizontal') or current_margins.right()
    bottom = arg('bottom') or arg('vertical') or current_margins.bottom()

    widget.setContentsMargins(left, top, right, bottom)
    return widget


QLabel.with_margins = _with_margins
QWidget.with_margins = _with_margins
