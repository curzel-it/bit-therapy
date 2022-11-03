import AppKit
import SwiftUI

public protocol Handler: AnyObject {
    var icon: NSImage? { get }
    func showHome()
    func hidePets()
    func showPets()
}

public protocol LocalizedContentProvider {
    var menuTitle: String { get }
    func translation(for key: MenuItem) -> String
}

public enum MenuItem: String {
    case home
    case hide
    case show
    case quit
}

public class StatusBar {
    static let manager = StatusBarManager()
    
    public static func show(
        with handler: Handler,
        localizedContent lang: LocalizedContentProvider
    ) {
        StatusBar.manager.show(with: handler, localizedContent: lang)
    }
    
    public static func hide() {
        StatusBar.manager.hide()
    }
}

class StatusBarManager: NSObject {
    private var statusItem: NSStatusItem?
    private weak var handler: Handler?
    
    func show(
        with handler: Handler,
        localizedContent: LocalizedContentProvider
    ) {
        self.handler = handler
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.image = handler.icon
        item.menu = buildMenu(with: localizedContent)
        statusItem = item
    }
    
    func hide() {
        handler = nil
        guard let item = statusItem else { return }
        NSStatusBar.system.removeStatusItem(item)
        statusItem = nil
    }
    
    private func buildMenu(with lang: LocalizedContentProvider) -> NSMenu {
        let menu = NSMenu(title: lang.menuTitle)
        menu.items = [
            buildItem(key: .home, action: #selector(showHome), with: lang),
            buildItem(key: .hide, action: #selector(hidePets), with: lang),
            buildItem(key: .show, action: #selector(showPets), with: lang),
            buildItem(key: .quit, action: #selector(closeApp), with: lang)
        ]
        return menu
    }
    
    private func buildItem(
        key: MenuItem,
        action: Selector,
        with lang: LocalizedContentProvider
    ) -> NSMenuItem {
        let item = NSMenuItem(
            title: lang.translation(for: key),
            action: action,
            keyEquivalent: key.rawValue
        )
        item.isEnabled = true
        item.target = self
        return item
    }
    
    @objc private func showHome() { handler?.showHome() }
    @objc private func hidePets() { handler?.hidePets() }
    @objc private func showPets() { handler?.showPets() }
    @objc private func closeApp() { NSApp.terminate(self) }
}
