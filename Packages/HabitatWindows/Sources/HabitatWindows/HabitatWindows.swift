//
// Pet Therapy.
//

import AppKit
import AppState
import Biosphere
import Combine
import EntityWindow

import Pets
import Schwifty
import Squanch
import SwiftUI

open class HabitatWindows<Habitat: LiveEnvironment>: NSObject, NSWindowDelegate {
    
    weak var habitat: Habitat?
    
    var windows: [EntityWindow] = []
    
    var whenAllWindowsHaveBeenClosed: () -> Void
    
    private var childrenCanc: AnyCancellable!
    
    public let tag: String
    
    public init(
        id: String,
        for habitat: Habitat,
        whenAllWindowsHaveBeenClosed: @escaping () -> Void
    ) {
        self.tag = "HabitatWindows-\(id)"
        self.habitat = habitat
        self.whenAllWindowsHaveBeenClosed = whenAllWindowsHaveBeenClosed
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
    
    private func showWindow(representing entity: Entity, in habitat: Habitat) {
        let window = dequeueWindow(representing: entity, in: habitat)
        window.show()
        window.makeKey()
    }
    
    private func dequeueWindow(representing entity: Entity, in habitat: Habitat) -> EntityWindow {
        if let window = existingWindow(representing: entity) {
            return window
        }
        let window = newWindow(representing: entity, in: habitat)
        printDebug(tag, "Created window for", entity.id)
        register(window)
        return window
    }
    
    open func newWindow(representing entity: Entity, in habitat: Habitat) -> EntityWindow {
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
    
    public func windowWillClose(_ notification: Notification) {
        guard windows.count > 0 else { return }
        guard let windowBeingClosed = notification.object as? EntityWindow else { return }
        windows.removeAll { $0 == windowBeingClosed }
        
        printDebug(tag, "Window for", windowBeingClosed.entity.id, "has been closed")
        
        if windows.count == 0 {
            printDebug(tag, "All windows have been closed")
            whenAllWindowsHaveBeenClosed()
            kill()
        }
    }
    
    // MARK: - Kill Switch
    
    public func kill() {
        whenAllWindowsHaveBeenClosed = {}
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
        printDebug(tag, "Terminated")
    }
}
