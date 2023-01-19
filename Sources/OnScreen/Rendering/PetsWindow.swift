// 
// Pet Therapy.
// 

import AppKit
import Combine
import Schwifty
import SwiftUI
import Yage

class PetsWindow: NSWindow {
    private let tag: String
    private let world: World
    private var previousEntitiesIds: [String] = []
    private var timer: Timer!
    private var lastUpdate = Date.timeIntervalSinceReferenceDate
    
    init(representing world: World) {
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
        contentView?.subviews
            .compactMap { $0 as? EntityView }
            .forEach { $0.update() }
    }
    
    private func spawnViewsForNewEntities() {
        world.children.forEach { entity in
            guard entity.isRenderable else { return }
            guard !previousEntitiesIds.contains(entity.id) else { return }
            spawnView(for: entity)
        }
        previousEntitiesIds = world.children.map { $0.id }
    }
    
    private func spawnView(for child: Entity) {
        guard var contentView else { return }
        let view = EntityView(representing: child)
        
        for subview in contentView.subviews {
            guard let otherEntityView = subview as? EntityView else { continue }
            if child.zIndex < otherEntityView.zIndex {
                contentView.addSubview(view, positioned: .above, relativeTo: otherEntityView)
                return
            }
        }
        contentView.addSubview(view)
    }
}

private extension Entity {
    var isRenderable: Bool {
        !isStatic && sprite != nil
    }
}
