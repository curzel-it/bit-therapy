import sys
from PyQt6.QtWidgets import QApplication
from isort import Config
from app.app_window import AppWindow
from config.assets import PetsAssetsProvider
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

app = QApplication(sys.argv)

config_storage = ConfigStorage()
config = config_storage.load_config()

singletons = [
    (AssetsProvider, lambda: PetsAssetsProvider(['../../PetsAssets'])),
    (CapabilitiesDiscoveryService, lambda: PetsCapabilities()),
    (ConfigStorage, lambda: config_storage),
    (Config, lambda: config),
    (CoordinateSystem, lambda: QtCoordinateSystem()),
    (ImageInterpolationUseCase, lambda: ImageInterpolationUseCaseImpl()),
    (OnScreenCoordinator, lambda: OnScreenCoordinatorImpl()),
    (Screens, lambda: Screens(app)),
    (SpeciesProvider, lambda: SpeciesProvider('../../Species')),
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

app_window = AppWindow()
app_window.show()

on_screen_coordinator = Dependencies.instance(OnScreenCoordinator)
on_screen_coordinator.show()

app.exec()
