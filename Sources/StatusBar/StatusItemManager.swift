//
// Pet Therapy.
// 

import AppKit
import SwiftUI

class StatusBarItems {
    
    static let main = MainStatusBarItem()
}

class MainStatusBarItem: NSObject {
    
    private var statusItem: NSStatusItem?
    
    func setup() {
        guard AppState.global.statusBarIconEnabled else { return }
        guard statusItem == nil else { return }
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let icon = NSImage(named: "StatusBarIcon")
        icon?.isTemplate = true
        item.button?.image = icon
        item.menu = buildMenu()
        statusItem = item
    }
    
    func remove() {
        guard let item = statusItem else { return }
        NSStatusBar.system.removeStatusItem(item)
        statusItem = nil
    }
    
    private func buildMenu() -> NSMenu {
        let menu = NSMenu(title: "Desktop Pets")
        menu.items = [
            buildItem("home", #selector(showHome)),
            buildItem("settings", #selector(showSettings)),
            buildItem("hide", #selector(hidePet)),
            buildItem("show", #selector(showPet)),
            buildItem("about", #selector(showAbout)),
            buildItem("quit", #selector(closeApp))
        ]
        return menu
    }
    
    private func buildItem(_ key: String, _ action: Selector) -> NSMenuItem {
        let item = NSMenuItem(
            title: "menu.item.\(key)".localized(),
            action: action,
            keyEquivalent: key
        )
        item.isEnabled = true
        item.target = self
        return item
    }
    
    @objc private func showHome() {
        MainWindow.show()
        AppState.global.selectedPage = .home
    }
    
    @objc private func showSettings() {
        MainWindow.show()
        AppState.global.selectedPage = .settings
    }
    
    @objc private func showAbout() {
        MainWindow.show()
        AppState.global.selectedPage = .about
    }
    
    @objc private func hidePet() {
        OnScreenWindow.hide()
    }
    
    @objc private func showPet() {
        OnScreenWindow.show(onlyIfNeeded: true)
    }
    
    @objc private func closeApp() {
        NSApp.terminate(self)
    }
}
