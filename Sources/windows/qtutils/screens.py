import platform
from PyQt6.QtGui import QScreen
from PyQt6.QtWidgets import QApplication
from yage.utils.geometry import Rect, Size

from yage.utils.logger import Logger


class Screens:
    def __init__(self, app: QApplication):
        self.main = Screen(app.primaryScreen())

        if platform.system() == 'Darwin':
            Logger.log(
                'Screens', 'Loading mocked screens because... reasons...')
            self.main.size = Size(800, 600)
            self.main.frame.size = self.main.size


class Screen:
    def __init__(self, screen: QScreen):
        self.name = screen.name()
        self.size = Size(screen.size().width(), screen.size().height())
        self.frame = Rect(0, 0, self.size.width, self.size.height)
        self.scale_factor = screen.devicePixelRatio()
