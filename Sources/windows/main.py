import os
import sys
from PyQt6.QtWidgets import QApplication
from qt_material import apply_stylesheet
from app.app_window import AppWindow
from config.assets import PetsAssetsProvider
from config.config import Config
from config.config_storage import ConfigStorage
from config.species import SpeciesProvider
from di.di import Dependencies
from onscreen.environments.on_screen_coordinator import OnScreenCoordinator, OnScreenCoordinatorImpl
from onscreen.environments.world_elements_service import WorldElementsService
from onscreen.features.fantozzi_cloud import RainyCloudUseCase
from onscreen.features.ufo_abduction import UfoAbductionUseCase
from onscreen.interactions.desktop_obstacles_service import DesktopObstaclesService
from onscreen.models.capabilities import PetsCapabilities
from onscreen.rendering.coordinate_system import CoordinateSystem, QtCoordinateSystem
from onscreen.rendering.image_interpolation import ImageInterpolationUseCase
from onscreen.rendering.image_interpolation import ImageInterpolationUseCaseImpl
from qtutils.screens import Screens
from yage.models.assets import AssetsProvider
from yage.models.capability import CapabilitiesDiscoveryService


def _load_dependencies(
    app: QApplication,
    config_storage: ConfigStorage,
    assets_path: str,
    species_path: str
):
    singletons = [
        (AssetsProvider, lambda: PetsAssetsProvider([assets_path])),
        (CapabilitiesDiscoveryService, lambda: PetsCapabilities()),
        (ConfigStorage, lambda: config_storage),
        (Config, lambda: config_storage.load_config()),
        (CoordinateSystem, lambda: QtCoordinateSystem()),
        (ImageInterpolationUseCase, lambda: ImageInterpolationUseCaseImpl()),
        (OnScreenCoordinator, lambda: OnScreenCoordinatorImpl()),
        (Screens, lambda: Screens(app)),
        (SpeciesProvider, lambda: SpeciesProvider(species_path)),
        (WorldElementsService, lambda: WorldElementsService())
    ]
    for singleton, builder in singletons:
        Dependencies.register_singleton(singleton, builder)

    dependencies = [
        (DesktopObstaclesService, lambda: DesktopObstaclesService()),
        (RainyCloudUseCase, lambda: RainyCloudUseCase()),
        (UfoAbductionUseCase, lambda: UfoAbductionUseCase())
    ]
    for dependency, builder in dependencies:
        Dependencies.register(dependency, builder)


def load_theme(app):
    apply_stylesheet(app, theme='dark_pink.xml')


def launch_app(config_path, assets_path, species_path):
    app = QApplication([])
    load_theme(app)
    config_storage = ConfigStorage(config_path)

    _load_dependencies(app, config_storage, assets_path, species_path)

    app_window = AppWindow()
    app_window.show()

    on_screen_coordinator = Dependencies.instance(OnScreenCoordinator)
    on_screen_coordinator.show()

    app.exec()


if __name__ == '__main__':
    try:
        root = sys._MEIPASS
    except AttributeError:
        root = os.path.join('..', '..')

    launch_app(
        'desktop_pets_config.json',
        os.path.join(root, 'PetsAssets'),
        os.path.join(root, 'Species')
    )
