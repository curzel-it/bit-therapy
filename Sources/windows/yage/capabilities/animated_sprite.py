from typing import List
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.models.entity_state import EntityState
from yage.utils.geometry import Rect
from yage.utils.logger import Logger
from yage.utils.timed_content_provider import TimedContentProvider


class AnimatedSprite(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.last_frame_before_animations = subject.frame
        self.animation: TimedContentProvider = TimedContentProvider.none()
        self._last_state: EntityState = EntityState.DRAG

    def do_update(self, collisions: List[Collision], time: float):
        self._update_sprite_if_state_changed()
        self._load_next_content(time)
        self._store_frame_if_needed()

    def kill(self, autoremove: bool = True):
        self.subject.sprite = None
        super().kill(autoremove)
        self.animation = TimedContentProvider.none()

    def _update_sprite_if_state_changed(self):
        if self.subject.state == self._last_state:
            return
        self._last_state = self.subject.state
        self._update_sprite()

    def _load_next_content(self, time: float):
        next_content = self.animation.next_content(time)
        if not next_content:
            return
        self.subject.sprite = next_content

    def _store_frame_if_needed(self):
        if self.subject.state != EntityState.ANIMATION:
            return
        self.last_frame_before_animations = self.subject.frame

    def _update_sprite(self):
        path = self._sprite_for_state(self._last_state)
        if path is None or path == self.animation.id:
            return
        Logger.log(self.tag, "Loading", path)
        self.animation.clear_hooks()
        self.animation = self._build_animator(path, self._last_state)
        sprite = self.animation.current_content()
        if sprite:
            self.subject.sprite = sprite

    def _build_animator(self, animation: str, state: EntityState) -> TimedContentProvider:
        frames = self._sprites_for_state(state)
        if not frames or len(frames) == 0:
            Logger.log(self.tag, "No sprites to load")
            return TimedContentProvider.none()

        anim, required_loops = self.subject.animation()
        if anim is None or required_loops is None:
            return TimedContentProvider(animation, frames, self.subject.fps)
        
        return self._build_animator_for_animation(animation, frames, anim, required_loops)
    
    def _build_animator_for_animation(self, animation, frames, anim, required_loops):
        required_frame = anim.frame(self.subject)

        def check_animation_started(completed_loops):
            return self._handle_animation_started_if_needed(completed_loops, required_frame),

        def check_animation_completed(completed_loops):
            return self._handle_animation_completion_if_needed(completed_loops, required_loops),

        return TimedContentProvider(
            animation,
            frames,
            self.subject.fps,
            check_animation_started,
            check_animation_completed
        )

    def _handle_animation_started_if_needed(self, completed_loops: int, required_frame: Rect):
        if completed_loops != 0:
            return
        Logger.log(self.tag, "Animation started")
        self.subject.frame = required_frame
        self._enable_subject_movement(False)

    def _handle_animation_completion_if_needed(self, completed_loops: int, required_loops: int):
        if completed_loops != required_loops:
            return
        Logger.log(self.tag, "Animation completed")
        self.subject.frame = self.last_frame_before_animations
        self.subject.state = EntityState.MOVE
        self._enable_subject_movement(True)

    def _sprites_for_state(self, state: EntityState) -> List[str]:
        try:
            return self.subject.sprites_provider.frames(state)
        except AttributeError as exc:
            self._warn_no_sprite_provider(exc)
            return None

    def _sprite_for_state(self, state: EntityState) -> str:
        try:
            return self.subject.sprites_provider.sprite(state)
        except AttributeError as exc:
            self._warn_no_sprite_provider(exc)
            raise exc
        
    def _warn_no_sprite_provider(self, original_exception):
        message = "Please ensure a SpritesProvider is installed and implements `frames(state: EntityState)`"
        Logger.log(self.tag, message)
        Logger.log(self.tag, original_exception)

    def _enable_subject_movement(self, enabled: bool):
        try:
            self.subject.movement.is_enabled = enabled
        except AttributeError:
            pass
