import math
from typing import Callable, Optional


class TimedContentProvider:
    def __init__(
        self,
        provider_id: str,
        contents,
        fps: float,
        on_first_content_of_loop_loaded: Optional[Callable[[
            int], None]] = None,
        on_loop_completed: Optional[Callable[[int], None]] = None
    ):
        self.id = provider_id
        self.contents = contents
        self.frame_time = 1/fps if fps > 0 else 0
        self.loop_duracy = len(contents) * self.frame_time
        self.on_first_content_of_loop_loaded = on_first_content_of_loop_loaded
        self.on_loop_completed = on_loop_completed
        self.current_content_index = 0
        self.completed_loops = 0
        self.leftover_time = 0

    @classmethod
    def none(self):
        return self('', [], 10)

    def current_content(self):
        if self.current_content_index >= len(self.contents):
            return None
        return self.contents[self.current_content_index]

    def next_content(self, time: float):
        if self.frame_time <= 0 or len(self.contents) == 0:
            return None

        self._handle_first_content_of_first_loop_if_needed()

        time_since_last_content_change = time + self.leftover_time
        if time_since_last_content_change < self.frame_time:
            self.leftover_time = time_since_last_content_change
            return None

        contents_skipped = int(math.floor(
            time_since_last_content_change / self.frame_time))
        used_time = contents_skipped * self.frame_time
        self.leftover_time = time_since_last_content_change - used_time

        next_index = (self.current_content_index +
                      contents_skipped) % len(self.contents)
        if self.current_content_index != next_index:
            self._check_loop_completion(next_index)
            return self.contents[next_index]

        return None

    def _handle_first_content_of_first_loop_if_needed(self) -> None:
        if self.completed_loops == 0 and self.current_content_index == 0 and self.leftover_time == 0:
            if self.on_first_content_of_loop_loaded:
                self.on_first_content_of_loop_loaded(0)

    def _check_loop_completion(self, next_index: int) -> None:
        if next_index < self.current_content_index:
            self.completed_loops += 1
            if self.on_loop_completed:
                self.on_loop_completed(self.completed_loops)
            if self.on_first_content_of_loop_loaded:
                self.on_first_content_of_loop_loaded(self.completed_loops)
        self.current_content_index = next_index

    def clear_hooks(self) -> None:
        self.on_first_content_of_loop_loaded = None
        self.on_loop_completed = None
