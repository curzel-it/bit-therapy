import sys
from PyQt6.QtWidgets import QApplication

from app import *
from config import *
from di import *
from onscreen import *
from yage import *

app = QApplication(sys.argv)
screen = app.primaryScreen()
scale_factor = screen.devicePixelRatio()

config_storage = ConfigStorage()
config = config_storage.load_config()

Dependencies.register_singleton("scale_factor", lambda: scale_factor)
Dependencies.register_singleton(AssetsProvider, lambda: AssetsProvider(['../../PetsAssets']))
Dependencies.register_singleton(CapabilitiesDiscoveryService, lambda: MyCapabilities())
Dependencies.register_singleton(ConfigStorage, lambda: config_storage)
Dependencies.register_singleton(Config, lambda: config)
Dependencies.register_singleton(SpeciesProvider, lambda: SpeciesProvider('../../Species'))

window = MainWindow()
window.show()
app.exec()