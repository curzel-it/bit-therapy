import random
from typing import List, Optional
from config.config import Config
from config.species import SpeciesProvider
from di.di import Dependencies
from onscreen.environments.world_elements_service import WorldElementsService
from onscreen.features.fantozzi_cloud import RainyCloudUseCase
from onscreen.features.ufo_abduction import UfoAbductionUseCase
from onscreen.interactions.desktop_obstacles_service import DesktopObstaclesService
from onscreen.models.pet_entity import PetEntity
from yage.models.species import Species
from yage.models.world import World


class ScreenEnvironment(World):
    def __init__(self, screen):
        super().__init__(screen.name, screen.frame)
        self._disposables = []
        self._rainy_cloud_use_case = Dependencies.instance(RainyCloudUseCase)
        self._settings = Dependencies.instance(Config)
        self._ufo_abduction_use_case = Dependencies.instance(
            UfoAbductionUseCase)
        self._desktop_obstacles = Dependencies.instance(
            DesktopObstaclesService)
        self._species_provider = Dependencies.instance(SpeciesProvider)
        self._world_elements = Dependencies.instance(WorldElementsService)
        self._load_additional_elements()
        self._bind_pets_on_stage()
        self._schedule_ufo_abduction()
        self._schedule_rainy_cloud()
        self._observe_windows_if_needed()

    def has_any_pets(self) -> bool:
        return any(isinstance(child, PetEntity) for child in self.children)

    def random_pet(self) -> Optional[PetEntity]:
        pets = [child for child in self.children if isinstance(
            child, PetEntity)]
        pets = [child for child in pets if child.speed !=
                0 and not child.is_ephemeral]
        if len(pets) > 0:
            return random.choice(pets)
        return None

    def add_pet_from_species(self, species: Species):
        entity = PetEntity(species, self)
        self.children.append(entity)

    def remove(self, species_to_remove: Species):
        self._settings.deselect(species_to_remove.id)
        to_remove = [
            child for child in self.children if child.species == species_to_remove]
        for child in to_remove:
            child.kill()
            self.children.remove(child)

    def _load_additional_elements(self):
        elements = self._world_elements.elements(self)
        self.children += elements

    def _observe_windows_if_needed(self):
        # TODO: Implement
        return

    def _schedule_ufo_abduction(self):
        # TODO: Implement
        return

    def _schedule_rainy_cloud(self):
        # TODO: Implement
        return

    def _bind_pets_on_stage(self):
        disposable = self._settings.selected_species.subscribe(
            lambda values: self._on_pet_selection_changed(values)
        )
        self._disposables.append(disposable)

    def _on_pet_selection_changed(self, new_selected_species: List[str]):
        self._remove_unselected_pets(new_selected_species)
        self._add_new_pets(new_selected_species)

    def _remove_unselected_pets(self, new_selected_species: List[str]):
        to_remove = [
            child for child in self.children if isinstance(child, PetEntity)]
        to_remove = [
            child for child in to_remove if child.species.id not in new_selected_species]
        for child in to_remove:
            child.kill()
            self.children.remove(child)

    def _add_new_pets(self, new_selected_species: List[str]):
        current_species = [child.species.id for child in self.children]
        missing_species = set(new_selected_species) - set(current_species)

        for species_id in missing_species:
            new_species = self._species_provider.species_by_id[species_id]
            self.add_pet_from_species(new_species)

    def kill(self):
        for d in self._disposables:
            d.dispose()
        self._disposables = []
        super().kill()
        self._desktop_obstacles.stop()
