from PyQt6.QtCore import QTimer
from rx.subject import BehaviorSubject


def execute_on_main_thread(block):
    QTimer.singleShot(1, lambda: block())


def _subscribe_on_qt_main_thread(signal, block):
    return signal.subscribe(
        lambda value: execute_on_main_thread(lambda: block(value))
    )


BehaviorSubject.subscribe_on_qt_main_thread = _subscribe_on_qt_main_thread
