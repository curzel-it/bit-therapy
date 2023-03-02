import json
import re
from typing import List
from config.assets import AssetsProvider
from yage.models import Species
from yage.models.animations import EntityAnimation, EntityAnimationAnchorPoint
from yage.utils.logger import Logger

class SpeciesProvider:
    def __init__(self):
        self.assets = AssetsProvider.shared
        self.all_species: List[Species] = []
        self.species_by_id = {}

    def load(self, species_json_strings: List[str]):
        self.all_species = self._build_species(species_json_strings)
        self.species_by_id = {species.id: species for species in self.all_species}

    def _build_species(self, species_json_strings: List[str]) -> List[Species]:
        species = [self.species_from_json(json) for json in species_json_strings]
        species = list(set([s for s in species if s]))
        return species

    def species_from_json(self, json_string: str) -> Species:
        try:
            json_object = json.loads(json_string.encode('utf-8'))
            species = Species(**_to_snake_case(json_object))
            self._adjust_animations(species)
            return species
        except AttributeError:
            return None

    def _adjust_animations(self, species):
        # Need to figure out how to import jsonpickle to do this automatically.
        animations = [_to_snake_case(a) for a in species.animations]
        animations = [EntityAnimation(**a) for a in animations]        
        for animation in animations:
            if animation.anchor.__class__ is not EntityAnimationAnchorPoint:
                try: 
                    animation.anchor = EntityAnimationAnchorPoint[animation.anchor]
                except:
                    animation.anchor = EntityAnimationAnchorPoint.BOTTOM
        species.animations = animations


def _to_snake_case(dictionary: dict) -> dict:
    result = {}
    for key, value in dictionary.items():
        key = re.sub(r'(?<!^)(?=[A-Z])', '_', key).lower()
        result[key] = value
    return result
