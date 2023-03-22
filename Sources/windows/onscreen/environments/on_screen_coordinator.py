from typing import List
from PyQt6.QtWidgets import QWidget
from di import Dependencies
from onscreen.environments.screen_environment import ScreenEnvironment
from onscreen.rendering.world_window import WorldWindow
from qtutils.screens import Screens
from yage.models.species import Species
from yage.utils.logger import Logger


class OnScreenCoordinator:
    def __init__(self):
        self.worlds: List[ScreenEnvironment] = []

    def show(self):
        raise NotImplementedError()

    def hide(self):
        raise NotImplementedError()

    def remove(self, species: Species):
        raise NotImplementedError()


class OnScreenCoordinatorImpl(OnScreenCoordinator):
    def __init__(self):
        super().__init__()
        self.worlds: List[ScreenEnvironment] = []
        self.windows: List[QWidget] = []

    def show(self):
        self.hide()
        Logger.log("OnScreen", "Starting...")
        self.loadWorlds()
        self.spawn_windows()

    def loadWorlds(self):
        screen = Dependencies.instance(Screens).main
        self.worlds = [ScreenEnvironment(screen)]

    def hide(self):
        Logger.log("OnScreen", "Hiding everything...")
        for world in self.worlds:
            world.kill()
        self.worlds.clear()
        for window in self.windows:
            window.close()
        self.windows.clear()

    def remove(self, species: Species):
        for world in self.worlds:
            world.remove(species)

    def spawn_windows(self):
        self.windows = [WorldWindow(world) for world in self.worlds]
        for window in self.windows:
            window.show()
