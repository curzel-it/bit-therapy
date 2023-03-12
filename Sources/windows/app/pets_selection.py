from PyQt6.QtCore import Qt
from PyQt6.QtGui import QPixmap
from PyQt6.QtWidgets import QWidget, QLabel, QGridLayout, QSizePolicy
from config import AssetsProvider, Config
from config.species import SpeciesProvider
from di import *
from qtutils import *

class PetsSelection(QWidget):
    def __init__(self, width):
        super().__init__()
        self.grid_width = width - pixels(Spacing.LG.value * 2)
        self.config = Dependencies.instance(Config)
        self.species_provider = Dependencies.instance(SpeciesProvider)
        self.config.selected_species.subscribe(self._species_selection_changed)

    def _species_selection_changed(self, selected):
        all_species = [species.id for species in self.species_provider.all_species]
        self._load_layout(selected, all_species)

    def _load_layout(self, selected_species, all_species):
        layout = vertically_stacked(
            QLabel('Selected Pets')
                .title()
                .withMargins(left=Spacing.MD)
                .withMargins(top=Spacing.LG),
            _PetsGrid(selected_species, self.grid_width),
            QLabel('More Pets')
                .title()
                .withMargins(left=Spacing.MD)
                .withMargins(top=Spacing.XL),
            _PetsGrid(all_species, self.grid_width)
                .withMargins(bottom=Spacing.XXXXL),
            spacing = 0
        )
        self.set_scrollable(layout)

class _PetsGrid(QWidget):
    def __init__(self, species, width):
        super().__init__()
        self.number_of_columns = 6
        self.item_width = pixels(120)
        layout = QGridLayout(self)
        layout.setVerticalSpacing(pixels(Spacing.MD))
        layout.setAlignment(Qt.AlignmentFlag.AlignLeading)
        self.setFixedWidth(width)        
        
        column = 0
        for index, species in enumerate(species):
            item = PetItem(species)
            layout.addWidget(item, index // self.number_of_columns, column)
            column += 1 
            if column >= self.number_of_columns: column = 0

class PetItem(QWidget):
    def __init__(self, species):    
        super().__init__()
        self.config = Dependencies.instance(Config)
        self.species = species
        self.width = pixels(120)

        layout = vertically_stacked(
            self._preview(),
            self._title(),
            spacing = 8
        )
        self.setLayout(layout)
        self._make_clickable()

    def _make_clickable(self):
        self.mousePressEvent = lambda _: self.config.toggle_species_selected(self.species)
        
    def _title(self):
        label = QLabel(self.species)
        label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        label.setSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Preferred)
        label.setFixedWidth(self.width)        
        return label
        
    def _preview(self):
        size = self.width, pixels(80)
        path = Dependencies.instance(AssetsProvider).frames(self.species, 'front')[0]
        image = QPixmap(path).scaled(*size, Qt.AspectRatioMode.KeepAspectRatio, Qt.TransformationMode.FastTransformation)
        label = QLabel()
        label.setContentsMargins(pixels(Spacing.MD), 0, pixels(Spacing.MD), 0)
        label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        label.setPixmap(image)
        label.setSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        label.setFixedSize(*size)
        return label

