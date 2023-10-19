from PyQt6.QtWidgets import QMainWindow

from app.pets_selection import PetsSelection


class AppWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        window_width = 800
        self.grid = PetsSelection(window_width)
        self.setContentsMargins(0, 0, 0, 0)
        self.setCentralWidget(self.grid)
        self.setFixedSize(window_width, 700)
