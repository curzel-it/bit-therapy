import math
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QPixmap
from PyQt6.QtWidgets import QWidget, QScrollArea, QLabel, QGridLayout, QSizePolicy
import random
from config import AssetsProvider

class PetsGrid(QScrollArea):
    def __init__(self, species, width):
        super().__init__()
        pets_grid = _PetsGrid(species, width)
        self.setWidget(pets_grid)

class _PetsGrid(QWidget):
    def __init__(self, species, width):
        super().__init__()
        layout = QGridLayout(self)
        self.number_of_columns = 6
        self.item_width = 80
        self.setFixedWidth(width - 50)
        
        column = 0
        for index, species in enumerate(species):
            label = self._species_widget(species)
            layout.addWidget(label, index // self.number_of_columns, column)
            column += 1 
            if column >= self.number_of_columns: column = 0

    def _species_widget(self, species):
        size = self.item_width, self.item_width
        path = AssetsProvider.shared.frames(species, 'front')[0]
        image = QPixmap(path).scaled(*size, Qt.AspectRatioMode.KeepAspectRatio, Qt.TransformationMode.FastTransformation)
        label = QLabel(self)
        label.setPixmap(image)
        label.setSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        label.setFixedSize(*size)
        return label

