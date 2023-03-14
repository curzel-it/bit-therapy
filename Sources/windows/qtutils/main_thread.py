from PyQt6.QtCore import Qt, QTimer, QMetaObject
from rx.subject import BehaviorSubject

def execute_on_main_thread(foo):
    QTimer.singleShot(1, lambda: foo())

def _subscribe_on_qt_main_thread(signal, foo):
    return signal.subscribe(
        lambda value: execute_on_main_thread(lambda: foo(value))
    )

BehaviorSubject.subscribe_on_qt_main_thread = _subscribe_on_qt_main_thread

