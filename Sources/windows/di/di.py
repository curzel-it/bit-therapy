import pdb


class classproperty(object):
    def __init__(self, f):
        self.f = f

    def __get__(self, obj, owner):
        return self.f(owner)


class Dependencies:
    def __init__(self):
        self._container = Container()
        self._singletons_container = SingletonContainer()

    @classmethod
    def register(cls, key, builder):
        cls.shared._container.register(key, builder)

    @classmethod
    def register_singleton(cls, key, builder):
        cls.shared._singletons_container.register(key, builder)

    @classmethod
    def instance(cls, key):
        try:
            return cls.shared._singletons_container.instance(key)
        except KeyError:
            return cls.shared._container.instance(key)

    @classproperty
    def shared(cls):
        try:
            return cls._instance
        except:
            cls._instance = Dependencies()
            return cls._instance


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
        except KeyError:
            raise KeyError(
                f'Missing builder for `{key}`, did you register it?')


class SingletonContainer(Container):
    def __init__(self):
        super().__init__()
        self._instances = {}

    def instance(self, key):
        if object := self._instances.get(key):
            return object
        object = super().instance(key)
        self._instances[key] = object
        return object
