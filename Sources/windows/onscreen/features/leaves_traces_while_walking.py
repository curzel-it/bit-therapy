from datetime import datetime
from yage.models.capability import Capability
from yage.models.entity import Entity
from yage.models.entity_state import EntityState
from yage.utils.geometry import Point


class LeavesTracesWhileWalking(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.species_for_trace_entities = None
        self.time_between_spawns = 5
        self.trace_expiration_time = 1
        self.traces = []
        self.is_enabled = True

    def do_update(self, collisions, time):
        if self.should_spawn_trace():
            self.spawn_trace()
        self.remove_expired_traces()

    def kill(self, autoremove=True):
        super().kill(autoremove)
        for trace in self.traces:
            trace.kill(autoremove)
        self.traces = []

    def should_spawn_trace(self):
        if self.subject.state != EntityState.MOVE:
            return False
        if self._seconds_since(self.last_spawn_date()) <= self.time_between_spawns:
            return False
        return True

    def last_spawn_date(self):
        if not self.traces:
            return datetime.fromtimestamp(0)
        return self.traces[-1].creation_date

    def spawn_trace(self):
        if not self.species_for_trace_entities:
            return
        if not self.subject:
            return
        if not self.subject.world:
            return

        entity = Entity(
            species=self.species_for_trace_entities,
            id=LeavesTracesWhileWalking.next_trace_id(),
            frame=self.subject.frame.offset(point=self.trace_offset()),
            world=self.subject.world
        )
        entity.is_ephemeral = True
        self.subject.world.children.append(entity)
        self.traces.append(entity)

    def _seconds_since(self, date: datetime) -> int:
        return abs(int((datetime.now() - date).total_seconds()))

    def trace_offset(self):
        return Point(0, 0)

    def remove_expired_traces(self):
        for trace in self.traces:
            if self._seconds_since(trace.creation_date) > self.trace_expiration_time:
                self.remove(trace)

    def remove(self, trace):
        trace.kill()
        self.traces.remove(trace)

    @staticmethod
    def next_trace_id():
        try:
            LeavesTracesWhileWalking.incremental_id += 1
        except AttributeError:
            LeavesTracesWhileWalking.incremental_id = 1
        return f'Trace-{LeavesTracesWhileWalking.incremental_id}'
