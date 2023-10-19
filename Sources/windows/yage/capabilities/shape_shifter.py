from yage.models.capability import Capability
from yage.utils.geometry import Rect, Size


class ShapeShifter(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.animation_duracy = 1
        self.target_size = Size.zero()
        self.delta = Size.zero()
        self.remaining_time = 0

    def scale_linearly(self, size, duracy):
        self.target_size = size
        self.delta = Size(
            width=size.width - self.subject.frame.width,
            height=size.height - self.subject.frame.height
        )
        self.animation_duracy = duracy
        self.remaining_time = duracy
        self.is_enabled = True

    def do_update(self, collisions, time):
        self.subject.frame = self._updated_frame(time)
        self._check_completion(time)

    def _updated_frame(self, time):
        delta = Size(
            width=time * self.delta.width / self.animation_duracy,
            height=time * self.delta.height / self.animation_duracy
        )
        return Rect(
            x=self.subject.frame.origin.x - delta.width / 2,
            y=self.subject.frame.origin.y - delta.height / 2,
            width=self.subject.frame.width + delta.width,
            height=self.subject.frame.height + delta.height
        )

    def _check_completion(self, time):
        self.remaining_time -= time
        if self.remaining_time <= 0.0001:
            self.is_enabled = False
