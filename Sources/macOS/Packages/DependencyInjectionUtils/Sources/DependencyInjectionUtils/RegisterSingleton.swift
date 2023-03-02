import Swinject

public extension Container {
    @discardableResult
    func registerSingleton<Service>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service
    ) -> ServiceEntry<Service> {
        _register(serviceType, factory: factory, name: name)
            .inObjectScope(.container)
    }
}
