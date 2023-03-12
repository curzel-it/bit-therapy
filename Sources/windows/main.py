import platform
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
screen_size = screen.size().width(), screen.size().height()

Logger.log('App', 'Screen size is', screen_size)
if platform.system() == 'Darwin':
    Logger.log('App', 'Using smaller screen size of 800x600 because... reasons...')
    screen_size = 800, 600

config_storage = ConfigStorage()
config = config_storage.load_config()

Dependencies.register_singleton('screen_size', screen_size)
Dependencies.register_singleton('scale_factor', scale_factor)
Dependencies.register_singleton(AssetsProvider, lambda: AssetsProvider(['../../PetsAssets']))
Dependencies.register_singleton(CapabilitiesDiscoveryService, lambda: MyCapabilities())
Dependencies.register_singleton(ConfigStorage, lambda: config_storage)
Dependencies.register_singleton(Config, lambda: config)
Dependencies.register_singleton(SpeciesProvider, lambda: SpeciesProvider('../../Species'))

app_window = AppWindow()
app_window.show()

pets_window = PetsWindow()
pets_window.show()

app.exec()
