import unittest

from config import SpeciesProvider, AssetsProvider
from di import *
from yage.models.animations import EntityAnimation

class SpeciesProviderTests(unittest.TestCase):
    def setUp(self):
        Dependencies.register_singleton(AssetsProvider, AssetsProvider(['../../PetsAssets']))
        self.provider = SpeciesProvider()
        
    def test_parse_species(self):
        species = self.provider.species_from_json(ape_json)
        self.assertIsNotNone(species)
        self.assertEqual(species.id, 'ape')
        self.assertEqual(species.movement_path, 'walk')
        self.assertEqual(species.drag_path, 'drag')
        self.assertEqual(species.fps, 10)
        self.assertEqual(species.speed, 0.7)
        self.assertEqual(species.z_index, 0)
        self.assertEqual(species.tags, ['jungle'])
        self.assertEqual(len(species.capabilities), 11)
        self.assertEqual(len(species.animations), 3)
        self.assertEqual(species.animations[0].__class__, EntityAnimation)

ape_json = '''
{
  "animations": [
    {
      "id": "front",
      "position": "fromEntityBottomLeft",
      "requiredLoops": 5
    },
    {
      "id": "eat",
      "position": "fromEntityBottomLeft",
      "requiredLoops": 5
    },
    {
      "id": "sleep",
      "position": "fromEntityBottomLeft",
      "requiredLoops": 20
    }
  ],
  "capabilities": [
    "AnimatedSprite",
    "AnimationsProvider",
    "AutoRespawn",
    "BounceOnLateralCollisions",
    "Draggable",
    "FlipHorizontallyWhenGoingLeft",
    "Gravity",
    "LinearMovement",
    "PetsSpritesProvider",
    "AnimationsScheduler",
    "Rotating"
  ],
  "dragPath": "drag",
  "fps": 10,
  "zIndex": 0,
  "tags": ["jungle"],
  "id": "ape",
  "movementPath": "walk",
  "speed": 0.7
}
'''
