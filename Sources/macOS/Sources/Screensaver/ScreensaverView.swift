import Combine
import Schwifty
import SwiftUI
import Yage

struct ScreensaverView: View {
    @StateObject private var viewModel: ScreensaverViewModel
    @State private var worldSize: CGSize = .zero
    
    init() {
        @Inject var onScreen: OnScreenCoordinator
        onScreen.hide()
        onScreen.show()
        let world = onScreen.worlds.first ?? World(name: "", bounds: .zero)
        let vm = ScreensaverViewModel(representing: world)
        vm.start()
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            Background(size: viewModel.worldBounds.size)
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
    @Published var entities: [EntityViewModel] = []
    
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
        world.renderableChildren.forEach { entity in
            guard !previousEntitiesIds.contains(entity.id) else { return }
            add(entity)
        }
    }
    
    private func add(_ entity: RenderableEntity) {
        let vm = EntityViewModel(representing: entity)
        vm.scaleFactor = Screen.main?.scale ?? 1
        entities.append(vm)
    }
}

private struct Background: View {
    @EnvironmentObject var appState: AppState
    
    let size: CGSize
    
    var body: some View {
        Image(appState.background)
            .interpolation(.none)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width)
            .frame(height: size.height)
            .edgesIgnoringSafeArea(.all)
    }
}
