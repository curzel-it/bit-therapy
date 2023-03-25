import Combine
import Schwifty
import SwiftUI
import Yage

struct ScreensaverView: View {
    @EnvironmentObject var appConfig: AppConfig
    @StateObject private var viewModel: ScreensaverViewModel
    @State private var worldSize: CGSize = .zero
    
    private let tag = "ScreensaverView"
    
    init() {
        let vm = ScreensaverViewModel()
        vm.start()
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            ForEach(viewModel.entities, id: \.entityId) {
                ScreensaverEntityView(viewModel: $0)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(size: worldSize)
        .measureAvailableSize { size in
            guard size != worldSize else { return }
            viewModel.updateWorldSize(to: size)
        }
    }
}

private class ScreensaverViewModel: WorldViewModel, ObservableObject {
    @Inject var config: AppConfig
    @Published var entities: [EntityViewModel] = []
    
    private let tag = "screensaver"
    
    init() {
        @Inject var onScreen: OnScreenCoordinator
        onScreen.hide()
        onScreen.show()
        let world = onScreen.worlds.first ?? World(name: "screensaver", bounds: .zero)
        super.init(representing: world)
    }
    
    func updateWorldSize(to size: CGSize) {
        world.set(bounds: CGRect(origin: .zero, size: size))
    }
    
    override func loop() {
        super.loop()
        updateViews()
        removeOldEntities()
        addNewEntities()
    }
    
    private func updateViews() {
        entities.forEach { $0.update() }
    }
    
    private func removeOldEntities() {
        let previous = entities.map { $0.entityId }
        let current = world.renderableChildren.map { $0.id }
        let idsToRemove: [String] = previous.reduce(into: []) { result, id in
            if !current.contains(id) {
                result.append(id)
            }
        }
        entities.removeAll { idsToRemove.contains($0.entityId) }
    }
    
    private func addNewEntities() {
        let previousEntitiesIds = entities.map { $0.entityId }
        world.renderableChildren
            .filter { !previousEntitiesIds.contains($0.id) }
            .forEach { add($0) }
    }
    
    private func add(_ entity: RenderableEntity) {
        let vm = EntityViewModel(representing: entity, in: .topDown)
        vm.scaleFactor = Screen.main?.scale ?? 1
        entities.append(vm)
    }
}
