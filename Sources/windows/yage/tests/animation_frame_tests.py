import unittest

from yage.models.animations import EntityAnimation, EntityAnimationPosition
from yage.models.entity import Entity
from yage.utils.geometry import Rect, Size
from yage.models.species import SPECIES_AGENT
from yage.models.world import World


class AnimationFrameTests(unittest.TestCase):
    def setUp(self):
        self.entity = Entity(
            SPECIES_AGENT,
            "test",
            Rect(5, 5, 5, 5),
            World('', Rect(0, 0, 15,  15))
        )

    def test_animation_frame_is_same_as_entity_frame_if_no_custom_size_or_position_are_set(self):
        animation = EntityAnimation(
            "test",
            None,
            EntityAnimationPosition.ENTITY_TOP_LEFT,
            None
        )
        self.assertEqual(self.entity.frame, animation.frame(self.entity))

    def test_animation_frame_is_correct_when_larger_than_entity_from_bottom_left(self):
        animation = EntityAnimation(
            "test",
            Size(width=2, height=2),
            EntityAnimationPosition.FROM_ENTITY_BOTTOM_LEFT,
            None
        )
        expected = Rect(x=5, y=0, width=10, height=10)
        animation_frame = animation.frame(self.entity)
        self.assertEqual(expected, animation_frame)
        self.assertEqual(expected.bottom_left, animation_frame.bottom_left)
        self.assertEqual(self.entity.frame.bottom_left,
                         animation_frame.bottom_left)


if __name__ == '__main__':
    unittest.main()
