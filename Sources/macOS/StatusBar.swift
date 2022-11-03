import AppKit
import OnScreen
import StatusBarItems
import SwiftUI

import Foundation
class StatusBarCoordinator {
    static let shared = StatusBarCoordinator()
    
    func show() {
        StatusBar.show(with: self, localizedContent: self)
    }
    
    func hide() {
        StatusBar.hide()
    }
}

extension StatusBarCoordinator: StatusBarItems.Handler {
    var icon: NSImage? {
        let icon = NSImage(named: "StatusBarIcon")
        icon?.isTemplate = true
        return icon
    }
    
    func showHome() { MainScene.show() }
    func hidePets() { OnScreen.hide() }
    func showPets() { OnScreen.show(with: AppState.global) }
}

extension StatusBarCoordinator: StatusBarItems.LocalizedContentProvider {
    var menuTitle: String { "Desktop Pets" }
    
    func translation(for key: MenuItem) -> String {
        switch key {
        case .home: return Lang.Menu.item("home")
        case .hide: return Lang.Menu.item("hide")
        case .show: return Lang.Menu.item("show")
        case .quit: return Lang.Menu.item("quit")
        }
    }
}
