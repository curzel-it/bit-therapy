import json 
import sys
from PyQt6.QtWidgets import QApplication

from app import *
from config import Config

def load_config() -> Config:
    try:
        with open('config.json') as user_file:
            return Config(**json.load(user_file))
    except FileNotFoundError as e: 
        try:
            f = open('config.json', 'w')
            f.write('{}')
            f.close()
        except: pass
        return Config()
        
initialize(
    load_config(), 
    assets_folder=['../../PetsAssets'],
    species_folder='../../Species'
)

app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()