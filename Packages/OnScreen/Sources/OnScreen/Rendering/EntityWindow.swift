import AppKit
import Combine
import Schwifty
import SwiftUI
import Yage
import YageLive

class EntityWindow: NSWindow {
    let entity: Entity
    private(set) var expectedFrame: CGRect = .zero
    private var updater: WindowUpdater?
    private var entityView: EntityView!

    init(representing entity: Entity) {
        self.entity = entity
        super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        setupWindow()
        setupEntityView()
        setupUpdater()
    }

    private func setupEntityView() {
        guard let contentView else { return }
        let view = EntityView(representing: entity)
        view.frame = contentView.bounds
        contentView.addSubview(view)
        view.constrainToFillParent()
        entityView = view
    }

    private func setupUpdater() {
        updater = WindowUpdater.install(on: entity)
        updater?.window = self
    }

    private func setupWindow() {
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        isMovableByWindowBackground = false
        level = .statusBar
        collectionBehavior = .canJoinAllSpaces
        setFrame(entity.frame.bounds, display: true)
    }

    func onEntityUpdated() {
        updateFrameIfNeeded()
        entityView.onEntityUpdated()
        if !entity.isAlive { close() }
    }

    func onEntityKilled() {
        close()
    }
    
    override open func close() {
        super.close()
        updater?.kill()
        updater = nil
    }

    private func updateFrameIfNeeded() {
        guard entity.mouseDrag?.isBeingDragged != true else { return }
        let newFrame = CGRect(
            origin: .zero
                .offset(x: entity.frame.minX)
                .offset(y: entity.worldBounds.height)
                .offset(y: -entity.frame.maxY)
                .offset(x: entity.worldBounds.origin.x)
                .offset(y: -entity.worldBounds.origin.y),
            size: entity.frame.size
        )
        if newFrame != frame {
            expectedFrame = newFrame
            setFrame(newFrame, display: true, animate: false)
        }
    }
}

// MARK: - Updater

private class WindowUpdater: Capability {
    weak var window: EntityWindow?

    override func update(with collisions: Collisions, after time: TimeInterval) {
        window?.onEntityUpdated()
    }

    override func kill(autoremove: Bool = true) {
        Task { @MainActor in
            window?.onEntityKilled()
            window = nil
        }
        super.kill(autoremove: autoremove)
    }
}

// MARK: - Equatable

extension EntityWindow {
    static func == (lhs: EntityWindow, rhs: EntityWindow) -> Bool {
        lhs.entity == rhs.entity
    }
}
