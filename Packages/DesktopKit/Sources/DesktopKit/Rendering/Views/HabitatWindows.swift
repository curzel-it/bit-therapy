import AppKit
import Combine
import Schwifty
import Squanch
import SwiftUI
import Yage

open class HabitatWindows: NSObject, NSWindowDelegate {
    weak var habitat: LiveHabitat?
    public private(set) var windows: [EntityWindow] = []
    public private(set) var isAlive = true
    private var childrenCanc: AnyCancellable!
    
    let tag: String
    
    public init(for habitat: LiveHabitat?) {
        self.tag = "HabitatWindows-\(HabitatWindows.nextId())"
        self.habitat = habitat
        super.init()
        startSpawningWindows()
    }
    
    private func startSpawningWindows() {
        childrenCanc = habitat?.state.$children.sink { children in
            guard let habitat = self.habitat else { return }
            children
                .compactMap { $0 as? RenderableEntity }
                .forEach { child in
                    self.showWindow(representing: child, in: habitat)
                }
        }
    }
    
    // MARK: - Show Window
    
    private func showWindow(representing entity: RenderableEntity, in habitat: LiveHabitat) {
        let window = dequeueWindow(representing: entity, in: habitat)
        window.show()
        window.makeKey()
    }
    
    private func dequeueWindow(representing entity: RenderableEntity, in habitat: LiveHabitat) -> EntityWindow {
        if let window = existingWindow(representing: entity) {
            return window
        }
        let window = newWindow(representing: entity, in: habitat)
        printDebug(tag, "Created window for", entity.id)
        register(window)
        return window
    }
    
    open func newWindow(representing entity: RenderableEntity, in habitat: LiveHabitat) -> EntityWindow {
        EntityWindow(representing: entity, in: habitat)
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
    }
    
    // MARK: - Kill Switch
    
    open func kill() {
        isAlive = false
        childrenCanc?.cancel()
        childrenCanc = nil
        habitat = nil
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

private extension HabitatWindows {
    
    static var id: Int = 0
    
    static func nextId() -> Int {
        id += 1
        return id
    }
}