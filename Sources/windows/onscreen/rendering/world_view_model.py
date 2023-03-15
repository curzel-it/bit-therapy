from datetime import datetime
from PyQt6.QtCore import QTimer
from yage.models.world import World
from yage.utils.logger import Logger


class WorldViewModel:
    def __init__(self, world: World):
        self.world = world
        self.tag = f'Win-{world.name}'
        self._last_update = datetime.now()
        self._timer = None

    @property
    def world_bounds(self):
        return self.world.bounds

    def start(self, fps: float = 20):
        Logger.log(self.tag, "Starting...")
        if self._timer:
            self._timer.stop()
        self._timer = QTimer()
        self._timer.timeout.connect(self.loop)
        self._timer.start(1000 // fps)

    def stop(self):
        if self._timer:
            self._timer.stop()
        self.world.kill()
        Logger.log(self.tag, "Terminated.")

    def loop(self):
        now = datetime.now()
        frame_time = (now - self._last_update).total_seconds()
        self.world.update(frame_time)
        self._last_update = now
