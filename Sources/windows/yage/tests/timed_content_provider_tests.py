import unittest
from yage.utils.timed_content_provider import TimedContentProvider


class TimedContentProviderTests(unittest.TestCase):
    def test_loop_duracy_is_properly_calculated(self):
        contents = [0] * 12
        animation = TimedContentProvider(provider_id='', contents=contents, fps=12)
        self.assertEqual(animation.loop_duracy, 1)

    def test_zero_fps_leads_to_zero_loop_duracy_and_frame_time(self):
        animation = TimedContentProvider(provider_id='', contents=[1, 2, 3], fps=0)
        self.assertEqual(animation.loop_duracy, 0)
        self.assertEqual(animation.frame_time, 0)

    def test_zero_contents_leads_to_zero_loop_duracy(self):
        animation = TimedContentProvider(provider_id='', contents=[], fps=1)
        self.assertEqual(animation.loop_duracy, 0)

    def test_contents_update_when_needed(self):
        contents = [0] * 10
        animation = TimedContentProvider(provider_id='', contents=contents, fps=10)
        self.assertEqual(animation.current_content_index, 0)

        animation.next_content(0.05)
        self.assertEqual(animation.current_content_index, 0)

        animation.next_content(0.05)
        self.assertEqual(animation.current_content_index, 1)

        animation.next_content(0.05)
        self.assertEqual(animation.current_content_index, 1)

        animation.next_content(0.05)
        self.assertEqual(animation.current_content_index, 2)

        animation.next_content(0.75)
        self.assertEqual(animation.current_content_index, 9)

        animation.next_content(0.08)
        self.assertEqual(animation.current_content_index, 0)
