import os
from typing import List, Optional
from PyQt6.QtGui import QPixmap
from yage.models.assets import AssetsProvider
from yage.utils.logger import Logger


class _Asset:
    def __init__(self, path: str):
        self.path = path
        self.sprite = self._sprite_name_from_path(path)
        tokens = self.sprite.split('-')
        self.key = tokens[0] if len(tokens) > 0 else ''
        self.frame = int(tokens[-1]) if len(tokens) > 1 else 0

    def _sprite_name_from_path(self, path: str) -> str:
        return os.path.split(path)[-1].split('.')[0]


class PetsAssetsProvider(AssetsProvider):
    def __init__(self, folders: List[str]):
        super().__init__()
        self.tag = "AssetsProvider"
        self._all_assets_paths = []
        self._sorted_assets_by_key = {}
        self.reload_assets(folders)

    def frames(self, species: str, animation: str) -> List[str]:
        key = self._key(species, animation)
        assets = self._sorted_assets_by_key.get(key) or []
        return [asset.path for asset in assets]

    def image(self, sprite: str) -> Optional[QPixmap]:
        return QPixmap(sprite)

    def path(self, sprite: str) -> Optional[str]:
        try:
            key = self._key_from_sprite(sprite)
            matches = [
                asset for asset in self._sorted_assets_by_key[key] if asset.sprite == sprite]
            return matches[0].path
        except AttributeError:
            return None
        except KeyError:
            return None

    def all_assets_for_species(self, species) -> List[str]:
        return [path for path in self._all_assets_paths if self._is_path_of_species(path, species)]

    def reload_assets(self, folders: List[str]):
        Logger.log(self.tag, "Loading assets from", *folders)
        all_paths = [self._build_assets_paths(folder) for folder in folders]
        Logger.log(self.tag, "Found", len(all_paths), "assets")
        self._all_assets_paths = sorted(
            [path for paths in all_paths for path in paths])
        assets = [_Asset(path) for path in self._all_assets_paths]
        assets = sorted(assets, key=lambda asset: asset.frame)
        self._build_sorted_assets(assets)

    def _is_path_of_species(self, path, species) -> bool:
        file_name = os.path.split(path)[-1]
        if not file_name.startswith(species):
            return False
        rest_of_file_name = file_name.replace(species, '')
        if not rest_of_file_name.startswith('_'):
            return False
        return len(rest_of_file_name.split('_')) == 2

    def _build_sorted_assets(self, assets: List[_Asset]):
        by_key = {}
        for asset in assets:
            by_key[asset.key] = (by_key.get(asset.key) or []) + [asset]
        self._sorted_assets_by_key = by_key
        Logger.log(self.tag, "Found", len(
            self._sorted_assets_by_key), "sprites")

    def _all_assets(self, species: str) -> List[str]:
        return [path for path in self._all_assets_paths if species in path]

    def _build_assets_paths(self, folder) -> List[str]:
        images = [path for path in os.listdir(folder) if path.endswith('.png')]
        return [os.path.join(folder, path) for path in images]

    def _key(self, species: str, animation: str) -> str:
        return f'{species}_{animation}'

    def _key_from_sprite(self, sprite: str) -> str:
        return sprite.split("-")[0]
