import Schwifty
import SwiftUI
import Yage

class RightClickable: Capability {
    override func install(on subject: Entity) {
        super.install(on: subject)
        isEnabled = !subject.isEphemeral
    }
    
    func onRightClick(from window: SomeWindow?, at point: CGPoint) {
        // ...
    }
}

extension Entity {
    var rightClick: RightClickable? { capability(for: RightClickable.self) }
}

#if os(macOS)
class ShowMenuOnRightClick: RightClickable {
    weak var lastWindow: SomeWindow?
    
    override func onRightClick(from window: SomeWindow?, at point: CGPoint) {
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
            title: "home",
            keyEquivalent: "",
            action: #selector(showHome),
            target: self
        )
    }

    @objc func showHome() {
        MainScene.show()
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
        @Inject var onScreen: OnScreenCoordinator
        onScreen.hide()
    }
}
#else
class ShowMenuOnRightClick: RightClickable {}
#endif
