import AppKit
import DependencyInjectionUtils
import EntityRendering
import Swinject

class Dependencies {
    static func setup() {
        let container = Container()
        container.register(AppStateStorage.self) { _ in AppStateStorageImpl() }
        container.register(EntityViewsProvider.self) { _ in EntityViewsProvider() }
        
        let assets = PetsAssetsProviderImpl()
        container.registerSingleton(PetsAssetsProvider.self) { _ in assets }
        container.registerSingleton(EntityRendering.AssetsProvider.self) { _ in assets }
        
        Container.propertyWrapperResolver = container.synchronize()
    }
}
