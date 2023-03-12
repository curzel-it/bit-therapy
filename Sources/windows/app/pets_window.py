import platform
from PyQt6.QtCore import Qt, QEvent
from PyQt6.QtWidgets import QMainWindow, QLabel
from di import *
from qtutils import *

class PetsWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        screen_size = Dependencies.instance('screen_size')
        self.setContentsMargins(0, 0, 0, 0)
        self.setFixedSize(*screen_size)
        self.setCentralWidget(QLabel('test').title().align(Qt.AlignmentFlag.AlignCenter))

        if platform.system() != 'Darwin': 
            self._make_window_transparent()
    
    def _make_window_transparent(self):
        self.setWindowFlags(Qt.WindowType.FramelessWindowHint | Qt.WindowType.WindowStaysOnTopHint)
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        self.setAttribute(Qt.WidgetAttribute.WA_NoSystemBackground)
