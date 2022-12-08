import AppKit
import Combine
import Schwifty
import SwiftUI
import Yage
import YageLive

open class EntityWindow: NSWindow {
    public let entity: Entity
    public let world: LiveWorld
    private(set) var expectedFrame: CGRect = .zero
    private var mouseDrag: MouseDraggable?
    private var updater: WindowUpdater?

    public init(representing entity: Entity, in world: LiveWorld) {
        self.entity = entity
        self.world = world
        super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        setupWindow()
        setupMouseDrag()
        setupEntityView()
        setupUpdater()
    }

    private func setupEntityView() {
        let view = buildEntityView()
        contentView?.addSubview(view)
        view.constrainToFillParent()
    }

    private func setupUpdater() {
        let updater = WindowUpdater(for: self)
        world.state.children.append(updater)
        self.updater = updater
    }

    open func buildEntityView() -> NSView {
        let view = EntityView(representing: entity, in: world)
        setFrame(CGRect(size: view.frame.size), display: true)
        return view
    }

    private func setupWindow() {
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        isMovableByWindowBackground = !entity.isStatic
        level = .statusBar
        collectionBehavior = .canJoinAllSpaces
    }

    private func setupMouseDrag() {
        guard !entity.isStatic else { return }
        mouseDrag = entity.capability(for: MouseDraggable.self) ?? MouseDraggable.install(on: entity)
    }

    func onEntityUpdated() {
        updateFrameIfNeeded()
        if !entity.isAlive { close() }
    }

    override open func close() {
        super.close()
        updater?.kill()
        updater = nil
    }

    private func updateFrameIfNeeded() {
        guard mouseDrag?.isBeingDragged != true else { return }

        let newFrame = CGRect(
            origin: CGPoint(
                x: entity.frame.minX,
                y: world.state.bounds.height - entity.frame.maxY
            ),
            size: entity.frame.size
        )
        if newFrame != frame {
            expectedFrame = newFrame
            setFrame(newFrame, display: true, animate: false)
        }
    }
}

// MARK: - Updater

private class WindowUpdater: Entity {
    weak var window: EntityWindow?

    init(for window: EntityWindow) {
        self.window = window
        super.init(species: .agent, id: "window-updater-\(window.entity)", frame: .zero, in: .zero)
    }

    override func update(with collisions: Collisions, after time: TimeInterval) {
        window?.onEntityUpdated()
    }

    override func kill() {
        window = nil
        super.kill()
    }
}

// MARK: - Equatable

extension EntityWindow {
    static func == (lhs: EntityWindow, rhs: EntityWindow) -> Bool {
        lhs.entity == rhs.entity
    }
}
