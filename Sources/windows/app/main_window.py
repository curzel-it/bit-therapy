from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import QMainWindow, QLabel

from app.pets_selection import PetsGrid
from config import SpeciesProvider

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        species_ids = [species.id for species in SpeciesProvider.shared.all_species]
        window_width = 800

        self.grid = PetsGrid(species_ids, window_width)
        self.setCentralWidget(self.grid)
        self.setGeometry(500, 300, window_width, 700)
        # self.setWindowFlags(Qt.WindowType.FramelessWindowHint)
        # self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        # self.setGeometry(0, 0, 700, 700)
