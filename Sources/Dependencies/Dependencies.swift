import AppKit
import EntityRendering
import Swinject

class Dependencies {
    fileprivate static var resolver: Resolver!
    
    static func setup() {
        let container = Container()
        container.register(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.register(EntityViewsProvider.self) { _ in
            EntityViewsProvider(assetsProvider: PetsAssetsProvider.shared)            
        }
        resolver = container.synchronize()
    }
}

@propertyWrapper
class Inject<Value> {
    private var storage: Value?

    var wrappedValue: Value {
        storage ?? {
            guard let resolver = Dependencies.resolver else {
                fatalError("Missing call to `Dependencies.setup()`")
            }
            guard let value = resolver.resolve(Value.self) else {
                fatalError("Dependency `\(Value.self)` not found, register it in `Dependencies.setup()`")
            }
            storage = value
            return value
        }()
    }
}
