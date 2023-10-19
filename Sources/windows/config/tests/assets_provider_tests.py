import os
import unittest

from config.assets import PetsAssetsProvider


class SpeciesProviderTests(unittest.TestCase):
    def setUp(self):
        assets_path = os.path.join('..', '..', 'PetsAssets')
        self.provider = PetsAssetsProvider([assets_path])

    def test_assets_for_plain_species_id(self):
        species = 'mushroom'
        found_assets = self.provider.all_assets_for_species(species)
        expected_assets = []
        expected_assets += [f'{species}_drag-{i}.png' for i in range(0, 4)]
        expected_assets += [f'{species}_front-{i}.png' for i in range(0, 4)]
        expected_assets += [f'{species}_idle-{i}.png' for i in range(0, 8)]
        expected_assets += [f'{species}_walk-{i}.png' for i in range(0, 4)]
        expected_assets = sorted(expected_assets)
        found_assets = [os.path.split(path)[-1] for path in found_assets]
        self.assertEqual(expected_assets, found_assets)

    def test_assets_for_species_id_with_underscores(self):
        species = 'mushroom_amanita'
        found_assets = self.provider.all_assets_for_species(species)
        expected_assets = []
        expected_assets += [f'{species}_drag-{i}.png' for i in range(0, 4)]
        expected_assets += [f'{species}_front-{i}.png' for i in range(0, 4)]
        expected_assets += [f'{species}_idle-{i}.png' for i in range(0, 8)]
        expected_assets += [f'{species}_walk-{i}.png' for i in range(0, 4)]
        expected_assets = sorted(expected_assets)
        found_assets = [os.path.split(path)[-1] for path in found_assets]
        self.assertEqual(expected_assets, found_assets)

    def test_assets_for_mushroomwizard(self):
        species = 'mushroomwizard'
        found_assets = self.provider.all_assets_for_species(species)
        expected_assets = []
        expected_assets += [f'{species}_drag-{i}.png' for i in range(0, 6)]
        expected_assets += [f'{species}_front-{i}.png' for i in range(0, 15)]
        expected_assets += [f'{species}_sleep-{i}.png' for i in range(0, 12)]
        expected_assets += [f'{species}_walk-{i}.png' for i in range(0, 6)]
        expected_assets = sorted(expected_assets)
        found_assets = [os.path.split(path)[-1] for path in found_assets]
        self.assertEqual(expected_assets, found_assets)
