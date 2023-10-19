from typing import Callable, List
from PyQt6.QtWidgets import QWidget
from onscreen.rendering.entity_widget import EntityWidget
from yage.models.entity import Entity
from yage.models.world import World
from yage.utils.logger import Logger
from .world_view_model import WorldViewModel


class WorldWindowViewModel(WorldViewModel):
    def __init__(self, world: World, entity_widgets: Callable[[], List[QWidget]], add_widget: Callable[[QWidget], None]):
        super().__init__(world)
        Logger.log(self.tag, "Init...")
        self._previous_entities_ids = []
        self._entity_widgets = entity_widgets
        self._add_widget = add_widget

    def loop(self):
        super().loop()
        self._update_views()
        self._spawn_views_for_new_entities()

    def _update_views(self):
        for widget in self._entity_widgets():
            widget.update_entity()

    def _renderable_children(self):
        return [child for child in self.world.children if child.sprite is not None]

    def _spawn_views_for_new_entities(self):
        renderables = self._renderable_children()
        for entity in renderables:
            if entity.id in self._previous_entities_ids:
                return
            self._spawn_widget_for_entity(entity)
        self._previous_entities_ids = [entity.id for entity in renderables]

    def _spawn_widget_for_entity(self, entity: Entity):
        new_widget = EntityWidget(entity)
        self._add_widget(new_widget)
