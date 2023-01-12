import Schwifty
import SwiftUI

class ShowsMenuOnRightClick: RightClickable {
    weak var menu: NSView?

    override func onRightClick(with event: NSEvent) {
        guard isEnabled else { return }
        event.window?.contentView?.menu = petMenu()
    }

    private func petMenu() -> NSMenu {
        let menu = NSMenu(title: "MainMenu")
        menu.addItem(hideThisPetItem())
        menu.addItem(hideAllPetsItem())
        return menu
    }

    private func item(title: String, keyEquivalent: String, action: Selector, target: AnyObject) -> NSMenuItem {
        let item = NSMenuItem(
            title: NSLocalizedString("menu.\(title)", comment: title),
            action: action,
            keyEquivalent: keyEquivalent
        )
        item.target = self
        return item
    }

    private func hideThisPetItem() -> NSMenuItem {
        item(
            title: "hideThisPet",
            keyEquivalent: "",
            action: #selector(hideThisPet),
            target: self
        )
    }

    @objc func hideThisPet() {
        guard let species = subject?.species else { return }
        OnScreenCoordinator.remove(species: species)
    }

    private func hideAllPetsItem() -> NSMenuItem {
        item(
            title: "hideAllPet",
            keyEquivalent: "",
            action: #selector(hideAllPets),
            target: self
        )
    }

    @objc func hideAllPets() {
        OnScreenCoordinator.hide()
    }
}
