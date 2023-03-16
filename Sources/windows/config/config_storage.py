import json
from typing import Optional

from config.config import Config


class ConfigStorage:
    def __init__(self, path: str):
        self.config_file_path = path
        self._values = {}
        self._disposables = []
        self._config: Optional[Config] = None

    def load_config(self) -> Config:
        config = self._load_or_create_config()
        self._bind_config(config)
        return config

    def _bind_config(self, config):
        self._config = config
        self._disposables += [
            config.desktop_interactions.subscribe(
                lambda _: self._on_config_changed()),
            config.gravity_enabled.subscribe(
                lambda _: self._on_config_changed()),
            config.pet_size.subscribe(lambda _: self._on_config_changed()),
            config.selected_species.subscribe(
                lambda _: self._on_config_changed()),
            config.speed_multiplier.subscribe(
                lambda _: self._on_config_changed())
        ]

    def _on_config_changed(self):
        self._update_values_from_config()
        self._write_values_to_config_file()

    def _update_values_from_config(self):
        self._values['desktop_interactions'] = self._config.desktop_interactions.value
        self._values['gravity_enabled'] = self._config.gravity_enabled.value
        self._values['pet_size'] = self._config.pet_size.value
        self._values['selected_species'] = self._config.selected_species.value
        self._values['speed_multiplier'] = self._config.speed_multiplier.value

    def _write_values_to_config_file(self):
        with open(self.config_file_path, 'w', encoding='utf-8') as f:
            f.write(json.dumps(self._values, indent=2))

    def _load_or_create_config(self):
        try:
            return self._load_config_from_file()
        except FileNotFoundError:
            self._create_empty_config_file()
            return Config()

    def _load_config_from_file(self):
        with open(self.config_file_path, encoding='utf-8') as f:
            config = Config(**json.load(f))
            return config

    def _create_empty_config_file(self):
        with open(self.config_file_path, 'w', encoding='utf-8') as f:
            f.write('{}')
