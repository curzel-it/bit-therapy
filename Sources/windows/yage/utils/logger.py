from datetime import datetime
from enum import Enum


class Logger:
    _logger = None

    @classmethod
    def debug(self, *args, **kwargs):
        Logger.log(self, *args, **kwargs, level=LogLevel.DEBUG)

    @classmethod
    def verbose(self, *args, **kwargs):
        Logger.log(self, *args, **kwargs, level=LogLevel.VERBOSE)

    @classmethod
    def error(self, *args, **kwargs):
        Logger.log(self, *args, **kwargs, level=LogLevel.ERROR)

    @classmethod
    def log(self, *args, **kwargs):
        date = datetime.now().strftime('%H:%M:%S.%f')[:-3]
        tokens = [str(it) for it in args]
        body = ' '.join(tokens[1:])
        level = kwargs.get('level') or LogLevel.VERBOSE
        message = f'{level.value}: {date} [{tokens[0]}] {body}'
        print(message)


class LogLevel(Enum):
    VERBOSE = 'V'
    DEBUG = 'D'
    ERROR = 'E'
