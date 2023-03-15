from typing import Optional

from yage.utils.logger import Logger


class Capability:
    def __init__(self, subject):
        self.subject = subject
        self.is_enabled = True
        self.tag = f'{subject.id}][{type(self).__name__}'
        Logger.log(subject.id, f'Installing {type(self).__name__}')

    def update(self, collisions, time):
        if self.is_enabled:
            self.do_update(collisions, time)

    def do_update(self, collisions, time):
        pass

    def kill(self, autoremove=True):
        if autoremove:
            self._remove_from_subject_capabilities()
        self.subject = None
        self.is_enabled = False

    def _remove_from_subject_capabilities(self):
        self.subject.capabilities = [
            c for c in self.subject.capabilities if c.tag != self.tag]


class CapabilitiesDiscoveryService:
    #pylint: disable=unused-argument
    def capability(self, capability_id: str) -> Optional[Capability]:
        return None
