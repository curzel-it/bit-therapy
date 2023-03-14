from typing import Tuple
from config import *
from di import *
from onscreen import *
from yage import *

"""
def initialize(config: Config, assets_folder: str, species_folder: str):
    load_config(config)
    Dependencies.instance(AssetsProvider) = AssetsProvider(assets_folder)
    Dependencies.instance(SpeciesProvider) = SpeciesProvider(species_folder)
    Dependencies.instance(CapabilitiesDiscoveryService) = MyCapabilities()

def load_config(config: Config) -> Config:
    Dependencies.instance(Config) = config

def build_worlds(screens_geometry: List[str]) -> List[World]:
    return [World(*name_and_frame(geo)) for geo in screens_geometry]

def entity_builder(species, world): 
    return PetEntity(
        species, 
        world, 
        pet_size = Dependencies.instance(Config).pet_size,
        gravity = Dependencies.instance(Config).gravity_enabled,
    )

def handle_species_selection_changed(species_ids: List[str], worlds: List[World]):
    species = [Dependencies.instance(SpeciesProvider).species_by_id.get(id) for id in species_ids]
    species = [s for s in species if s is not None]    
    for world in worlds:
        world.handle_species_selection_changed(species, entity_builder)

def name_and_frame(geometry: str) -> Tuple[str, Rect]:
    name, geometry = geometry.split('@')
    return name, Rect.from_geometry(geometry)
"""