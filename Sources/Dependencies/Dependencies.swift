import AppKit
import CustomPets
import DependencyInjectionUtils
import EntityRendering
import Swinject
import Yage

class Dependencies {
    static func setup() {
        let container = Container()
        container.register(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.register(DeletePetUseCase.self) { _ in DeletePetUseCaseImpl() }
        container.register(ImportDragAndDropPetUseCase.self) { _ in ImportDragAndDropPetUseCaseImpl() }
        container.register(ExportPetUseCase.self) { _ in ExportPetUseCaseImpl() }
        container.register(EntityViewsProvider.self) { _ in EntityViewsProvider() }
        container.register(CapabilitiesDiscoveryService.self) { _ in PetsCapabilitiesDiscoveryService() }
        container.register(CustomPets.ResourcesProvider.self) { _ in CustomPetsResourcesProviderImpl() }
        container.register(CustomPets.SpeciesProvider.self) { _ in CustomPetsSpeciesProviderImpl() }
        container.register(CustomPets.LocalizedResources.self) { _ in CustomPetsLocalizedResourcesImpl() }
        
        let assets = PetsAssetsProviderImpl()
        container.registerSingleton(PetsAssetsProvider.self) { _ in assets }
        container.registerSingleton(EntityRendering.AssetsProvider.self) { _ in assets }
        
        Container.propertyWrapperResolver = container.synchronize()
    }
}
