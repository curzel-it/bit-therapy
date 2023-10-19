import AppKit
import SwiftUI

class StatusBarCoordinator {
    @Inject private var onScreen: OnScreenCoordinator
    
    static let shared = StatusBarCoordinator()
    private var statusItem: NSStatusItem?

    func show() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.image = NSImage(named: "StatusBarIcon")
        item.button?.image?.isTemplate = true
        item.menu = buildMenu()
        statusItem = item
    }

    func hide() {
        guard let item = statusItem else { return }
        NSStatusBar.system.removeStatusItem(item)
        statusItem = nil
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu(title: Lang.appName)
        menu.items = [
            buildItem(key: .home, action: #selector(showHome)),
            buildItem(key: .hide, action: #selector(hidePets)),
            buildItem(key: .show, action: #selector(showPets)),
            buildItem(key: .quit, action: #selector(closeApp))
        ]
        return menu
    }

    private func buildItem(key: MenuItem, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(
            title: key.name,
            action: action,
            keyEquivalent: key.rawValue
        )
        item.isEnabled = true
        item.target = self
        return item
    }
    
    @objc private func showHome() { MainScene.show() }
    @objc private func hidePets() { onScreen.hide() }
    @objc private func showPets() { onScreen.show() }
    @objc private func closeApp() { NSApp.terminate(self) }
}
    
private enum MenuItem: String {
    case home
    case hide
    case show
    case quit
        
    var name: String {
        Lang.name(forMenuItem: rawValue)
    }
}
