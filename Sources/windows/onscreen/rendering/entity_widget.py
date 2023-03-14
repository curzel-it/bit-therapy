from functools import cached_property
from PyQt6.QtCore import Qt, QSize, QPoint
from PyQt6.QtGui import QCursor
from PyQt6.QtWidgets import QLabel
from onscreen.rendering.entity_view_model import EntityViewModel
from yage.models.entity import Entity
from yage.utils.geometry import Size
from yage.utils.logger import Logger

class EntityWidget(QLabel):
    def __init__(self, entity: Entity):
        super().__init__()
        self._disposables = []
        self._view_model = EntityViewModel(entity)
        self.tag = f'View-{self._view_model.entity_id}'
        self._update_frame_from_entity_frame(entity.frame)
        self._bind_frame()
        self._bind_image()
        self._bind_lifecycle()

    @cached_property
    def entity_id(self): 
        return self._view_model.entity_id
    
    def update_entity(self):
        self._view_model.update()    
    
    def _bind_frame(self):
        d = self._view_model.frame.subscribe_on_qt_main_thread(
            lambda f: self._update_frame_from_entity_frame(f)
        )
        self._disposables.append(d)

    def _update_frame_from_entity_frame(self, frame):
        self.setFixedSize(frame.size.as_qsize())
        self.move(frame.origin.as_qpoint())

    def _bind_image(self): 
        def update_image(self, image):
            if image:
                self.setPixmap(image)
        d = self._view_model.image.subscribe_on_qt_main_thread(
            lambda f: update_image(self, f)
        )
        self._disposables.append(d)

    def _bind_lifecycle(self): 
        def check_alive(self, is_alive):
            if not is_alive:
                Logger.log(self.tag, 'Entity is dead')
                self._kill()
        d = self._view_model.is_alive.subscribe_on_qt_main_thread(
            lambda f: check_alive(self, f)
        )
        self._disposables.append(d)

    def mousePressEvent(self, event):
        if event.button() == Qt.MouseButton.LeftButton:
            self._view_model.mouse_down()

    def mouseReleaseEvent(self, event):
        if event.button() == Qt.MouseButton.LeftButton:
            self._view_model.drag_ended()
        elif event.button() == Qt.MouseButton.RightButton:
            self._view_model.right_mouse_up()

    def mouseMoveEvent(self, event):
        pos = (event.pos() + self.pos()).as_point()
        Logger.log(self.tag, 'Mouse moved to', pos)
        self._view_model.dragged_to(pos)

    def _kill(self):        
        Logger.log(self.tag, 'Removing...')
        for d in self._disposables: d.dispose()
        self._disposables = []
        self.setParent(None)

    def closeEvent(self, event):
        Logger.log(self.tag, 'Got closing event...')
        self._kill()
        event.accept()
