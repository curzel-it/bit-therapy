import Swinject

public extension Container {
    static var propertyWrapperResolver: Resolver!
}

@propertyWrapper
public class Inject<Value> {
    private var storage: Value?
    
    public init() {}
    
    public var wrappedValue: Value {
        storage ?? {
            guard let resolver = Container.propertyWrapperResolver else {
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
