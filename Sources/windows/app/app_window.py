from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import QMainWindow, QLabel

from app.pets_selection import PetsSelection
from config import SpeciesProvider
from di import *

class AppWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        window_width = 800
        self.grid = PetsSelection(window_width)
        self.setContentsMargins(0, 0, 0, 0)
        self.setCentralWidget(self.grid)
        self.setFixedSize(window_width, 700)