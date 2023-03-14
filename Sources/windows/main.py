import sys
from PyQt6.QtWidgets import QApplication
from app import *
from config import *
from di import *
from onscreen import *
from qtutils.main_thread import execute_on_main_thread
from qtutils.screens import Screens
from yage.models.capability import CapabilitiesDiscoveryService

app = QApplication(sys.argv)

config_storage = ConfigStorage()
config = config_storage.load_config()

Dependencies.register_singleton(AssetsProvider, lambda: PetsAssetsProvider(['../../PetsAssets']))
Dependencies.register_singleton(CapabilitiesDiscoveryService, lambda: PetsCapabilities())
Dependencies.register_singleton(ConfigStorage, lambda: config_storage)
Dependencies.register_singleton(Config, lambda: config)
Dependencies.register_singleton(CoordinateSystem, lambda: QtCoordinateSystem())
Dependencies.register_singleton(ImageInterpolationUseCase, lambda: ImageInterpolationUseCaseImpl())
Dependencies.register_singleton(OnScreenCoordinator, lambda: OnScreenCoordinatorImpl())
Dependencies.register_singleton(Screens, lambda: Screens(app))
Dependencies.register_singleton(SpeciesProvider, lambda: SpeciesProvider('../../Species'))
Dependencies.register_singleton(WorldElementsService, lambda: WorldElementsService())

Dependencies.register(DesktopObstaclesService, lambda: DesktopObstaclesService())
Dependencies.register(RainyCloudUseCase, lambda: RainyCloudUseCase())
Dependencies.register(UfoAbductionUseCase, lambda: UfoAbductionUseCase())

app_window = AppWindow()
app_window.show()

on_screen_coordinator = Dependencies.instance(OnScreenCoordinator)
on_screen_coordinator.show()

app.exec()
