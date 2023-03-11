from app import MainWindow
import sys
from PyQt6.QtWidgets import QApplication

from app import initialize
from config import Config

initialize(
    Config(), 
    assets_folder=['../../PetsAssets'],
    species_folder='../../Species'
)

app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()
