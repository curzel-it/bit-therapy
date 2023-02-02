import AppKit
import DependencyInjectionUtils
import EntityRendering
import Swinject
import Yage

class Dependencies {
    static func setup() {
        let container = Container()
        container.register(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.register(DeletePetCoordinator.self) { _ in DeletePetButtonCoordinator() }
        container.register(ImportPetCoordinator.self) { _ in ImportPetDragAndDropCoordinator() }
        container.register(ExportPetCoordinator.self) { _ in ExportPetButtonCoordinator() }
        container.register(EntityViewsProvider.self) { _ in EntityViewsProvider() }
        container.register(CapabilitiesDiscoveryService.self) { _ in PetsCapabilitiesDiscoveryService() }
        
        let assets = PetsAssetsProviderImpl()
        container.registerSingleton(PetsAssetsProvider.self) { _ in assets }
        container.registerSingleton(EntityRendering.AssetsProvider.self) { _ in assets }
        
        Container.propertyWrapperResolver = container.synchronize()
    }
}
