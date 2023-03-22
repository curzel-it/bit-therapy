import platform
from PyQt6.QtCore import Qt, QTimer
from PyQt6.QtWidgets import QWidget
from di import Dependencies
from onscreen.rendering.entity_widget import EntityWidget
from onscreen.rendering.world_window_view_model import WorldWindowViewModel
from qtutils.screens import Screens
from yage.models.world import World


class WorldWindow(QWidget):
    def __init__(self, world: World):
        super().__init__()
        screen_size = Dependencies.instance(Screens).main.size
        self._view_model = WorldWindowViewModel(
            world,
            entity_widgets=self._list_entity_widgets,
            add_widget=self._add_widget
        )
        self.setContentsMargins(0, 0, 0, 0)
        self.setFixedSize(screen_size.width, screen_size.height)
        self._customize_window()
        self._view_model.start()

    def _list_entity_widgets(self):
        return self.findChildren(EntityWidget)

    def _add_widget(self, widget):
        QTimer.singleShot(1, lambda: self._add_widget_now(widget))

    def _add_widget_now(self, widget):
        widget.setParent(self)
        widget.show()

    def _customize_window(self):
        if platform.system() != 'Darwin':
            self._make_window_transparent()

    def _make_window_transparent(self):
        self.setWindowFlags(Qt.WindowType.FramelessWindowHint |
                            Qt.WindowType.WindowStaysOnTopHint)
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        self.setAttribute(Qt.WidgetAttribute.WA_NoSystemBackground)
