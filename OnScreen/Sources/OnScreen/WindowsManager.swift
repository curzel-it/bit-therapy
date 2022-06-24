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
import SwiftUI

class WindowsManager: NSObject, NSWindowDelegate {
    
    private var windows: [EntityWindow] = []
    
    weak var viewModel: ViewModel?
    
    init(for viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func showWindow(
        representing entity: Entity,
        in viewModel: ViewModel
    ) {
        let window = window(representing: entity, in: viewModel)
        register(window)
        window.show()
    }
    
    private func window(
        representing entity: Entity,
        in viewModel: ViewModel
    ) -> EntityWindow {
        if let window = existingWindow(representing: entity) {
            return window
        }
        if let pet = entity as? PetEntity {
            return PetWindow(representing: pet, in: viewModel)
        } else {
            return EntityWindow(representing: entity, in: viewModel)
        }
    }
    
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
    
    func windowWillClose(_ notification: Notification) {
        guard windows.count > 0 else { return }
        guard let windowBeingClosed = notification.object as? EntityWindow else { return }
        windows.removeAll { $0 == windowBeingClosed }
        if windows.count == 0 { kill() }
    }
    
    func kill() {
        windows.forEach { window in
            window.delegate = nil
            if window.isVisible {
                window.close()
            }
        }
        windows = []
        viewModel?.windowsManager = nil
        viewModel?.kill(animated: false)
    }
}
