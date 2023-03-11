import math
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QPixmap, QFont
from PyQt6.QtWidgets import QWidget, QScrollArea, QLabel, QGridLayout, QSizePolicy, QVBoxLayout
from config import AssetsProvider
from qtutils import *

class PetsSelection(QWidget):
    def __init__(self, selected_species, all_species, width):
        super().__init__()

        grid_width = width - 40
        layout = vertically_stacked(
            QLabel('Selected Pets').withMargins(left = 20).withFontSize(21).bold(),
            _PetsGrid(selected_species, grid_width),
            QLabel('More Pets').withMargins(left = 20).withFontSize(21).bold(),
            _PetsGrid(all_species, grid_width),
            spacing = 50
        )
        self.setScrollable(layout)

class _PetsGrid(QWidget):
    def __init__(self, species, width):
        super().__init__()
        self.number_of_columns = 6
        self.item_width = 120
        layout = QGridLayout(self)
        layout.setVerticalSpacing(20)
        self.setFixedWidth(width - 20)        
        
        column = 0
        for index, species in enumerate(species):
            item = _PetItem(species)
            layout.addWidget(item, index // self.number_of_columns, column)
            column += 1 
            if column >= self.number_of_columns: column = 0

class _PetItem(QWidget):
    def __init__(self, species):    
        super().__init__()
        layout = vertically_stacked(
            self._preview(species),
            self._title(species),
            spacing = 8
        )
        self.setLayout(layout)
        
    def _title(self, species):
        label = QLabel(species.id)
        label.setSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Preferred)
        label.setFixedWidth(120)        
        return label
        
    def _preview(self, species):
        size = 80, 80
        path = AssetsProvider.shared.frames(species.id, 'front')[0]
        image = QPixmap(path).scaled(*size, Qt.AspectRatioMode.KeepAspectRatio, Qt.TransformationMode.FastTransformation)
        label = QLabel()
        label.setPixmap(image)
        label.setSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        label.setFixedSize(*size)
        return label

