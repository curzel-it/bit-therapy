import SwiftUI
import Swinject
import Yage

class Dependencies {
    static func setup() {
        let container = Container()
        container.registerSingleton(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.registerSingleton(OnScreenCoordinator.self) { _ in OnScreenCoordinatorImpl() }
        container.registerSingleton(PetsAssetsProvider.self) { _ in PetsAssetsProviderImpl() }
        container.registerSingleton(SpeciesNamesRepository.self) { _ in SpeciesNamesRepositoryImpl() }
        container.registerSingleton(SpeciesProvider.self) { _ in SpeciesProviderImpl() }
        
        container.register(CustomPetsResourcesProvider.self) { _ in CustomPetsResourcesProviderImpl() }
        container.register(DeletePetButtonCoordinator.self) { _ in DeletePetButtonCoordinatorImpl() }
        container.register(DeletePetUseCase.self) { _ in DeletePetUseCaseImpl() }
        container.register(DesktopObstaclesService.self) { _ in DesktopObstaclesServiceImpl() }
        container.register(ExportPetButtonCoordinator.self) { _ in ExportPetButtonCoordinatorImpl() }
        container.register(ExportPetUseCase.self) { _ in ExportPetUseCaseImpl() }
        container.register(ImportDragAndDropPetUseCase.self) { _ in ImportDragAndDropPetUseCaseImpl() }
        container.register(ImportVerifier.self) { _ in ImportVerifierImpl() }
        container.register(LaunchAtLoginUseCase.self) { _ in LaunchAtLoginUseCaseImpl() }
        container.register(RainyCloudUseCase.self) { _ in RainyCloudUseCaseImpl() }
        container.register(RenamePetButtonCoordinator.self) { _ in RenamePetButtonCoordinatorImpl() }
        container.register(WorldElementsService.self) { _ in WorldElementsServiceImpl() }
        container.register(UfoAbductionUseCase.self) { _ in UfoAbductionUseCaseImpl() }
        
        Container.propertyWrapperResolver = container.synchronize()
        
        Capabilities.discovery = PetsCapabilitiesDiscoveryService()
    }
}

#if os(macOS)
typealias SomeView = NSView
typealias SomeWindow = NSWindow
#else
typealias SomeView = UIView
typealias SomeWindow = UIWindow
#endif
