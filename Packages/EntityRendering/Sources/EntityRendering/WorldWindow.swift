import AppKit
import Combine
import DependencyInjectionUtils
import Schwifty
import SwiftUI

class WorldWindow: NSWindow {
    private let tag: String
    private let world: RenderableWorld
    private var previousEntitiesIds: [String] = []
    private var timer: Timer!
    private var lastUpdate = Date.timeIntervalSinceReferenceDate
    
    private var entityViews: [EntityView] {
        contentView?.subviews.compactMap { $0 as? EntityView } ?? []
    }
    
    init(representing world: RenderableWorld) {
        self.world = world
        self.tag = "Win-\(world.name)"
        super.init(
            contentRect: .zero,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        configureWindow()
        start(fps: 20)
    }
    
    override func close() {
        super.close()
        world.kill()
        Logger.log(tag, "Terminated.")
    }
    
    private func configureWindow() {
        setFrame(world.bounds, display: true)
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces]
    }
    
    private func start(fps: Double) {
        Logger.log(tag, "Starting...")
        timer?.invalidate()
        timer = Timer(timeInterval: 1 / fps, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            self.loop()
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    private func loop() {
        let now = Date.timeIntervalSinceReferenceDate
        let frameTime = now - lastUpdate
        world.update(after: frameTime)
        updateViews()
        spawnViewsForNewEntities()
        lastUpdate = now
    }

    private func updateViews() {
        entityViews.forEach { $0.update() }
    }
    
    private func spawnViewsForNewEntities() {
        world.renderableChildren.forEach { entity in
            guard !previousEntitiesIds.contains(entity.id) else { return }
            spawnView(for: entity)
        }
        previousEntitiesIds = world.renderableChildren.map { $0.id }
    }
    
    private func spawnView(for child: RenderableEntity) {
        guard let contentView else { return }
        let view = PixelArtEntityView(representing: child)
        
        for otherEntityView in entityViews where child.zIndex < otherEntityView.zIndex {
            contentView.addSubview(view, positioned: .above, relativeTo: otherEntityView)
            return
        }
        contentView.addSubview(view)
    }
}
