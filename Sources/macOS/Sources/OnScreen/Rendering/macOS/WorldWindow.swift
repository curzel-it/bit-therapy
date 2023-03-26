import AppKit
import Combine
import Swinject
import Schwifty
import SwiftUI
import Yage

protocol EntityView: SomeView {
    var entityId: String { get }
    var zIndex: Int { get }
    func update()
}

class WorldWindow: NSWindow {
    static weak var current: NSWindow?
    private let viewModel: WorldWindowViewModel
    
    init(representing world: World) {
        self.viewModel = WorldWindowViewModel(representing: world)
        super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        configureWindow()
        viewModel.addSubview = { [weak self] in self?.addSubview(newView: $0) }
        viewModel.entityViews = { [weak self] in self?.entityViews() ?? [] }
        viewModel.start()
        WorldWindow.current = self
    }
    
    override func close() {
        WorldWindow.current = nil
        viewModel.stop()
        super.close()
    }
    
    private func entityViews() -> [EntityView] {
        contentView?.subviews.compactMap { $0 as? EntityView } ?? []
    }
    
    private func configureWindow() {
        setFrame(viewModel.worldBounds, display: true)
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces]
    }
    
    private func addSubview(newView: EntityView) {
        guard let contentView else { return }
        contentView.addSubview(newView)
        contentView.subviews = entityViews().sorted { $0.zIndex < $1.zIndex }
    }
}

private class WorldWindowViewModel: WorldViewModel {
    private var previousEntitiesIds: [String] = []
    var entityViews: () -> [EntityView] = { [] }
    var addSubview: (EntityView) -> Void = { _ in }
    
    override func loop() {
        super.loop()
        updateViews()
        spawnViewsForNewEntities()
    }
    
    private func updateViews() {
        entityViews().forEach { $0.update() }
    }
    
    private func spawnViewsForNewEntities() {
        world.renderableChildren.forEach { entity in
            guard !previousEntitiesIds.contains(entity.id) else { return }
            spawnView(for: entity)
        }
        previousEntitiesIds = world.renderableChildren.map { $0.id }
    }
    
    private func spawnView(for child: RenderableEntity) {
        let newView = PixelArtEntityView(representing: child)
        addSubview(newView)
    }
}
