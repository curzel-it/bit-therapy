import AppKit
import Combine
import Schwifty
import SwiftUI
import Yage
import YageLive

class OnScreenWindows: NSObject, NSWindowDelegate {
    private(set) var worlds: [LiveWorld]
    private(set) var windows: [EntityWindow] = []
    private(set) var isAlive = true
    private var disposables = Set<AnyCancellable>()

    let tag: String

    init(for worlds: [LiveWorld]) {
        tag = "OnScreenWindows-\(OnScreenWindows.nextId())"
        self.worlds = worlds
        super.init()
        startSpawningWindows()
    }

    private func startSpawningWindows() {
        worlds.forEach { world in
            world.$children
                .receive(on: DispatchQueue.main)
                .sink { [weak self] children in
                    guard let self else { return }
                    children
                        .filter { $0.sprite != nil }
                        .sorted { $0.zIndex < $1.zIndex }
                        .forEach { self.showWindow(representing: $0, in: world) }
                }
                .store(in: &disposables)
        }
    }

    // MARK: - Show Window

    private func showWindow(representing entity: Entity, in world: LiveWorld) {
        let window = dequeueWindow(representing: entity, in: world)
        window.show()
        window.orderedIndex = -entity.zIndex
    }

    private func dequeueWindow(representing entity: Entity, in world: LiveWorld) -> EntityWindow {
        if let window = existingWindow(representing: entity) {
            return window
        }
        let window = newWindow(representing: entity)
        Logger.log(tag, "Created window for", entity.id)
        register(window)
        return window
    }

    func newWindow(representing entity: Entity) -> EntityWindow {
        EntityWindow(representing: entity, assetsProvider: OnScreenCoordinator.assetsProvider)
    }

    // MARK: - Cached Windows

    private func register(_ window: EntityWindow) {
        let alreadyPresent = windows.contains { $0.entity.id == window.entity.id }
        if !alreadyPresent {
            windows.append(window)
        }
        window.delegate = self
    }

    func existingWindow(representing entity: Entity) -> EntityWindow? {
        windows.first { $0.entity == entity }
    }

    // MARK: - Window Closed

    func windowWillClose(_ notification: Notification) {
        guard windows.count > 0 else { return }
        guard let windowBeingClosed = notification.object as? EntityWindow else { return }
        windows.removeAll { $0 == windowBeingClosed }
        Logger.log(tag, "Window for", windowBeingClosed.entity.id, "has been closed")

        if isAlive && windows.count == 0 {
            Logger.log(tag, "No more windows, terminating")
            kill()
            OnScreenCoordinator.hide()
        }
    }

    // MARK: - Kill Switch

    func kill() {
        isAlive = false
        disposables.removeAll()
        worlds.removeAll()
        windows.forEach { window in
            window.delegate = nil
            if window.isVisible {
                window.close()
            }
        }
        windows = []
        Logger.log(tag, "Terminated.")
    }
}

// MARK: - Ids

private extension OnScreenWindows {
    static var id: Int = 0

    static func nextId() -> Int {
        id += 1
        return id
    }
}
