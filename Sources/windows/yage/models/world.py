from typing import List
from yage.models.entity import Entity
from yage.models.hotspots import Hotspot
from yage.models.species import Species
from yage.utils.geometry import Rect


class World:
    def __init__(self, name: str, bounds: Rect):
        self.name = name
        self.children = []
        self.set_bounds(bounds)

    def set_bounds(self, new_bounds: Rect):
        self.bounds = new_bounds
        hotspots = [hotspot.value for hotspot in Hotspot]
        old_bounds = [child for child in self.children if child.id in hotspots]
        for bound in old_bounds:
            bound.kill()
        self.children = [
            child for child in self.children if child.id not in hotspots]
        self.children += self._hotspot_entities()

    def update(self, time: float):
        for child in self.children:
            if not child.is_static:
                collisions = child.collisions(self.children)
                child.update(collisions, time)

    def kill(self):
        for child in self.children:
            child.kill()
        self.children = []

    def handle_species_selection_changed(self, species: List[Species], entity_provider):
        entities_to_eliminate = [
            e for e in self.children if e.species not in species and not e.is_static]
        for entity in entities_to_eliminate:
            entity.kill()
        self.children = [
            e for e in self.children if e not in entities_to_eliminate]

        new_species = [s for s in species if s not in [
            e.species for e in self.children]]
        new_entities = [entity_provider(s, self.bounds) for s in new_species]
        self.children.extend(new_entities)

    def _hotspot_entities(self) -> List[Entity]:
        return [
            Hotspot.build_top_bound(self),
            Hotspot.build_bottom_bound(self),
            Hotspot.build_left_bound(self),
            Hotspot.build_right_bound(self)
        ]
