from PyQt6.QtCore import Qt
from PyQt6.QtGui import QPixmap
from PyQt6.QtWidgets import QWidget, QLabel, QGridLayout, QSizePolicy
from config import AssetsProvider, Config
from config.species import SpeciesProvider
from di.di import Dependencies
from yage.utils.geometry import Size

# pylint: disable=wildcard-import,unused-wildcard-import
from qtutils import *


class PetsSelection(QWidget):
    def __init__(self, width):
        super().__init__()
        self._disposables = []
        self.grid_width = width - Spacing.LG.value * 2
        self.config = Dependencies.instance(Config)
        self.species_provider = Dependencies.instance(SpeciesProvider)
        self._bind_selected_species()

    def _bind_selected_species(self):
        disposable = self.config.selected_species.subscribe_on_qt_main_thread(
            self._species_selection_changed
        )
        self._disposables.append(disposable)

    def _species_selection_changed(self, selected):
        all_species = [
            species.id for species in self.species_provider.all_species]
        self._load_layout(selected, all_species)

    def _load_layout(self, selected_species, all_species):
        layout = vertically_stacked(
            QLabel('Selected Pets')
            .title()
            .with_margins(left=Spacing.MD)
            .with_margins(top=Spacing.LG),
            _PetsGrid(selected_species, self.grid_width),
            QLabel('More Pets')
            .title()
            .with_margins(left=Spacing.MD)
            .with_margins(top=Spacing.XL),
            _PetsGrid(all_species, self.grid_width)
            .with_margins(bottom=Spacing.XXXXL),
            spacing=0
        )
        self.set_scrollable(layout)

    def closeEvent(self, event):
        for d in self._disposables:
            d.dispose()
        self._disposables = []
        event.accept()


class _PetsGrid(QWidget):
    def __init__(self, species, width):
        super().__init__()
        self.number_of_columns = 6
        self.item_width = 120
        layout = QGridLayout(self)
        layout.setVerticalSpacing(Spacing.MD.value)
        layout.setAlignment(Qt.AlignmentFlag.AlignLeading)
        self.setFixedWidth(width)

        column = 0
        for index, species in enumerate(species):
            item = PetItem(species)
            layout.addWidget(item, index // self.number_of_columns, column)
            column += 1
            if column >= self.number_of_columns:
                column = 0


class PetItem(QWidget):
    def __init__(self, species):
        super().__init__()
        self.config = Dependencies.instance(Config)
        self.species = species
        self.width = 120
        self._load_layout()
        self._make_clickable()

    def _load_layout(self):
        layout = vertically_stacked(
            self._preview(),
            self._title(),
            spacing=8
        )
        self.setLayout(layout)

    def _make_clickable(self):
        self.mousePressEvent = self._on_clicked

    def _on_clicked(self):
        self.config.toggle_species_selected(self.species)

    def _title(self):
        label = QLabel(self.species)
        label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        label.setSizePolicy(QSizePolicy.Policy.Fixed,
                            QSizePolicy.Policy.Preferred)
        label.setFixedWidth(self.width)
        return label

    def _preview(self):
        size = self.width, 80
        label = QLabel()
        label.setContentsMargins(Spacing.MD.value, 0, Spacing.MD.value, 0)
        label.with_margins(horizontal=Spacing.MD)
        label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        label.setPixmap(self._image(size))
        label.setSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        label.setFixedSize(*size)
        return label

    def _image(self, size):
        assets_provider = Dependencies.instance(AssetsProvider)
        path = assets_provider.frames(self.species, 'front')[0]
        image_size = Size(*size).as_qsize()
        # Seems necessary on windows:
        # scale_factor = Dependencies.instance(Screens).main.scale_factor
        # image_size = Size(*size).scaled(scale_factor).as_qsize()
        image = QPixmap(path).scaled(
            image_size,
            Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.FastTransformation
        )
        return image
