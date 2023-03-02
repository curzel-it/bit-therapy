from datetime import datetime

class Logger:
    _logger = None

    @classmethod
    def log(self, *args):
        date = datetime.now().strftime('%H:%M:%S.%f')[:-3]
        tokens = [str(it) for it in args]
        body = ' '.join(tokens[1:])
        message = f'P: {date} [{tokens[0]}] {body}'
        print(message)