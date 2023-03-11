from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import QMainWindow, QLabel

from app.pets_selection import PetsSelection
from config import SpeciesProvider

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        all_species = SpeciesProvider.shared.all_species
        selected_species = all_species[:7]
        window_width = 800

        self.grid = PetsSelection(selected_species, all_species, window_width)        
        self.setContentsMargins(0, 0, 0, 0)
        self.setCentralWidget(self.grid)
        self.setFixedSize(window_width, 700)
        # self.setWindowFlags(Qt.WindowType.FramelessWindowHint)
        # self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        # self.setGeometry(0, 0, 700, 700)
