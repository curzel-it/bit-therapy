//
// Pet Therapy.
//

import AppKit
import Biosphere
import Combine
import Schwifty
import Squanch
import SwiftUI

open class HabitatWindows: NSObject, NSWindowDelegate {
    
    weak var habitat: LiveEnvironment?
    public private(set) var windows: [EntityWindow] = []
    public private(set) var isAlive = true
    private var childrenCanc: AnyCancellable!
    
    let tag: String
    
    public init(for habitat: LiveEnvironment?) {
        self.tag = "HabitatWindows-\(HabitatWindows.nextId())"
        self.habitat = habitat
        super.init()
        startSpawningWindows()
    }
    
    private func startSpawningWindows() {
        childrenCanc = habitat?.state.$children.sink { children in
            guard let habitat = self.habitat else { return }
            children
                .filter { $0.isDrawable }
                .forEach { child in
                    self.showWindow(representing: child, in: habitat)
                }
        }
    }
    
    // MARK: - Show Window
    
    private func showWindow(representing entity: Entity, in habitat: LiveEnvironment) {
        let window = dequeueWindow(representing: entity, in: habitat)
        window.show()
        window.makeKey()
    }
    
    private func dequeueWindow(representing entity: Entity, in habitat: LiveEnvironment) -> EntityWindow {
        if let window = existingWindow(representing: entity) {
            return window
        }
        let window = newWindow(representing: entity, in: habitat)
        printDebug(tag, "Created window for", entity.id)
        register(window)
        return window
    }
    
    open func newWindow(representing entity: Entity, in habitat: LiveEnvironment) -> EntityWindow {
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
