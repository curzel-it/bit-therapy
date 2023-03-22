# pylint: disable=no-member

class ClassProperty(object):
    def __init__(self, f):
        self.f = f

    def __get__(self, obj, owner):
        return self.f(owner)


class Dependencies:
    _instance = None

    def __init__(self):
        self.container = Container()
        self.singletons_container = SingletonContainer()

    @classmethod
    def register(cls, key, builder):
        cls.shared.container.register(key, builder)

    @classmethod
    def register_singleton(cls, key, builder):
        cls.shared.singletons_container.register(key, builder)

    @classmethod
    def instance(cls, key):
        try:
            return cls.shared.singletons_container.instance(key)
        except KeyError:
            return cls.shared.container.instance(key)

    @ClassProperty
    def shared(self) -> 'Dependencies':
        if self._instance is not None:
            return self._instance
        else:
            self._instance = Dependencies()
            return self._instance


class Container:
    def __init__(self):
        self._builders = {}

    def register(self, key, builder):
        if not callable(builder):
            raise TypeError(
                f'Tried to register builder {builder} for {key}, which is not a function')
        self._builders[key] = builder

    def instance(self, key):
        try:
            return self._builders[key]()
        except KeyError as exc:
            message = f'Missing builder for `{key}`, did you register it?'
            raise KeyError(message) from exc


class SingletonContainer(Container):
    def __init__(self):
        super().__init__()
        self._instances = {}

    def instance(self, key):
        if value := self._instances.get(key):
            return value
        value = super().instance(key)
        self._instances[key] = value
        return value
