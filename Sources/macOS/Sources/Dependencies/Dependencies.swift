import AppKit
import Swinject
import Yage

class Dependencies {
    static func setup() {
        let container = Container()
        container.registerSingleton(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.registerSingleton(SpeciesNamesRepository.self) { _ in SpeciesNamesRepositoryImpl() }
        container.registerSingleton(SpeciesProvider.self) { _ in SpeciesProviderImpl() }
        container.registerSingleton(PetsAssetsProvider.self) { _ in PetsAssetsProviderImpl() }
        container.register(DeletePetUseCase.self) { _ in DeletePetUseCaseImpl() }
        container.register(ImportDragAndDropPetUseCase.self) { _ in ImportDragAndDropPetUseCaseImpl() }
        container.register(ExportPetUseCase.self) { _ in ExportPetUseCaseImpl() }
        container.register(CustomPetsResourcesProvider.self) { _ in CustomPetsResourcesProviderImpl() }
        container.register(ImportVerifier.self) { _ in ImportVerifierImpl() }
        container.register(RainyCloudUseCase.self) { _ in RainyCloudUseCaseImpl() }
        container.register(UfoAbductionUseCase.self) { _ in UfoAbductionUseCaseImpl() }
        
        Container.propertyWrapperResolver = container.synchronize()
        
        Capabilities.discovery = PetsCapabilitiesDiscoveryService()
    }
}

extension Container {
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

extension Container {
    static var propertyWrapperResolver: Resolver!
}

@propertyWrapper
class Inject<Value> {
    private var storage: Value?
    
    init() {}
    
    var wrappedValue: Value {
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

