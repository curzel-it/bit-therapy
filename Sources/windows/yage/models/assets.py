from typing import List, Optional


class AssetsProvider():
    def frames(self, species: str, animation: str) -> List[str]:
        raise NotImplementedError()

    def path(self, sprite: str) -> Optional[str]:
        raise NotImplementedError()

    def all_assets_for_species(self, species) -> List[str]:
        raise NotImplementedError()

    def reload_assets(self, folders: List[str]):
        raise NotImplementedError()
