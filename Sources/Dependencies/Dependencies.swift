import AppKit
import CustomPets
import DependencyInjectionUtils
import Rendering
import Swinject
import Yage

class Dependencies {
    static func setup() {
        let container = Container()
        container.register(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.register(DeletePetUseCase.self) { _ in DeletePetUseCaseImpl() }
        container.register(ImportDragAndDropPetUseCase.self) { _ in ImportDragAndDropPetUseCaseImpl() }
        container.register(ExportPetUseCase.self) { _ in ExportPetUseCaseImpl() }
        container.register(CapabilitiesDiscoveryService.self) { _ in PetsCapabilitiesDiscoveryService() }
        container.register(CustomPets.ResourcesProvider.self) { _ in CustomPetsResourcesProviderImpl() }
        container.register(CustomPets.LocalizedResources.self) { _ in CustomPetsLocalizedResourcesImpl() }
        container.register(CustomPets.ImportVerifier.self) { _ in ImportVerifierImpl() }
        container.register(CustomPets.ImportVerifier.self) { _ in ImportVerifierImpl() }
        container.register(RainyCloudUseCase.self) { _ in RainyCloudUseCaseImpl() }
        container.register(UfoAbductionUseCase.self) { _ in UfoAbductionUseCaseImpl() }
        
        let assets = PetsAssetsProviderImpl()
        container.registerSingleton(PetsAssetsProvider.self) { _ in assets }
        container.registerSingleton(Rendering.AssetsProvider.self) { _ in assets }
        
        Container.propertyWrapperResolver = container.synchronize()
    }
}