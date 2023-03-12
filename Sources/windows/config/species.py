import json
import os
import re
from typing import List
from config.assets import AssetsProvider
from di import *
from yage.models import Species
from yage.models.animations import EntityAnimation, EntityAnimationPosition
from yage.utils.logger import Logger

class SpeciesProvider:
    def __init__(self, root):
        self.assets = Dependencies.instance(AssetsProvider)
        self.all_species: List[Species] = []
        self.species_by_id = {}
        self._load_from_folder(root)

    def _load_from_folder(self, root: str):
        paths = [path for path in os.listdir(root)]
        paths = [path for path in paths if path.endswith('.json')]
        paths = [os.path.join(root, path) for path in paths]
        self._load_from_files(paths)

    def _load_from_files(self, files: List[str]):
        def contents_of_file(path):
            f = open(path)
            content = f.read()
            f.close()
            return content
                
        jsons = [contents_of_file(path) for path in files]
        self._load_jsons(jsons)

    def _load_jsons(self, species_json_strings: List[str]):
        self.all_species = self._build_species(species_json_strings)
        self.species_by_id = {species.id: species for species in self.all_species}

    def _build_species(self, species_json_strings: List[str]) -> List[Species]:
        species = [self.species_from_json(json) for json in species_json_strings]
        species = list(set([s for s in species if s]))
        species = sorted(species, key=lambda s: s.id)
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
        animations = [_to_snake_case(a) for a in species.animations]
        animations = [EntityAnimation(**a) for a in animations]
        species.animations = animations


def _to_snake_case(dictionary: dict) -> dict:
    result = {}
    for key, value in dictionary.items():
        key = re.sub(r'(?<!^)(?=[A-Z])', '_', key).lower()
        result[key] = value
    return result
