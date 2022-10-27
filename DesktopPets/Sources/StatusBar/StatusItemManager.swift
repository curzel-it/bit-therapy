import AppKit
import OnScreen
import SwiftUI

class StatusBarItems {
    static let main = MainStatusBarItem()
}

class MainStatusBarItem: NSObject {    
    private var statusItem: NSStatusItem?
    
    func setup() {
        guard AppState.global.showInMenuBar else { return }
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
            buildItem("hide", #selector(hidePet)),
            buildItem("show", #selector(showPet)),
            buildItem("quit", #selector(closeApp))
        ]
        return menu
    }
    
    private func buildItem(_ key: String, _ action: Selector) -> NSMenuItem {
        let item = NSMenuItem(
            title: Lang.Menu.item(key),
            action: action,
            keyEquivalent: key
        )
        item.isEnabled = true
        item.target = self
        return item
    }
    
    @objc private func showHome() {
        MainWindow.show()
    }
    
    @objc private func hidePet() {
        OnScreen.hide()
    }
    
    @objc private func showPet() {
        OnScreen.show(with: AppState.global)
    }
    
    @objc private func closeApp() {
        NSApp.terminate(self)
    }
}
