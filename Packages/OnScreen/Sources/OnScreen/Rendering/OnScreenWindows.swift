import AppKit
import Combine
import Schwifty
import Squanch
import SwiftUI
import Yage

open class OnScreenWindows: NSObject, NSWindowDelegate {
    weak var world: LiveWorld?
    public private(set) var windows: [EntityWindow] = []
    public private(set) var isAlive = true
    private var childrenCanc: AnyCancellable!
    
    let tag: String
    
    public init(for world: LiveWorld?) {
        self.tag = "OnScreenWindows-\(OnScreenWindows.nextId())"
        self.world = world
        super.init()
        startSpawningWindows()
    }
    
    private func startSpawningWindows() {
        childrenCanc = world?.state.$children.sink { children in
            guard let world = self.world else { return }
            children
                .filter { $0.sprite != nil }
                .forEach { self.showWindow(representing: $0, in: world) }
        }
    }
    
    // MARK: - Show Window
    
    private func showWindow(representing entity: Entity, in world: LiveWorld) {
        let window = dequeueWindow(representing: entity, in: world)
        window.show()
        window.makeKey()
    }
    
    private func dequeueWindow(representing entity: Entity, in world: LiveWorld) -> EntityWindow {
        if let window = existingWindow(representing: entity) {
            return window
        }
        let window = newWindow(representing: entity, in: world)
        printDebug(tag, "Created window for", entity.id)
        register(window)
        return window
    }
    
    open func newWindow(representing entity: Entity, in world: LiveWorld) -> EntityWindow {
        EntityWindow(representing: entity, in: world)
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
    
    open func windowWillClose(_ notification: Notification) {
        guard windows.count > 0 else { return }
        guard let windowBeingClosed = notification.object as? EntityWindow else { return }
        windows.removeAll { $0 == windowBeingClosed }
        printDebug(tag, "Window for", windowBeingClosed.entity.id, "has been closed")
        
        if isAlive && windows.count == 0 {
            printDebug(tag, "No more windows, terminating")
            kill()
            OnScreen.hide()
        }
    }
    
    // MARK: - Kill Switch
    
    open func kill() {
        isAlive = false
        childrenCanc?.cancel()
        childrenCanc = nil
        world = nil
        windows.forEach { window in
            window.delegate = nil
            if window.isVisible {
                window.close()
            }
        }
        windows = []
        printDebug(tag, "Terminated.")
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
