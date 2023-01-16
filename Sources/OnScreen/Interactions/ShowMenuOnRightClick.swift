import Schwifty
import SwiftUI
import Yage

open class RightClickable: Capability {
    open func onRightClick(with event: NSEvent) {
        // ...
    }
}

extension Entity {
    var rightClick: RightClickable? { capability(for: RightClickable.self) }
}

class ShowMenuOnRightClick: RightClickable {
    weak var lastWindow: PetsWindow?
    
    override func onRightClick(with event: NSEvent) {
        guard let window = event.window as? PetsWindow else { return }
        lastWindow = window
        lastWindow?.contentView?.menu = petMenu()
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
        lastWindow?.close()
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
