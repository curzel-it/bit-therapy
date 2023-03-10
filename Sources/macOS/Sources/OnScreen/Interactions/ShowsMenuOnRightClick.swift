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
class ShowsMenuOnRightClick: RightClickable {
    @Inject private var onScreen: OnScreenCoordinator
    
    private weak var lastWindow: SomeWindow?
    
    override func onRightClick(from window: SomeWindow?, at point: CGPoint) {
        lastWindow = window
        lastWindow?.contentView?.menu = petMenu()
    }

    private func petMenu() -> NSMenu {
        let menu = NSMenu(title: "MainMenu")
        menu.addItem(followMouseItem())
        menu.addItem(showHomeItem())
        menu.addItem(hideAllPetsItem())
        return menu
    }

    private func item(title: String, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(
            title: "menu.\(title)".localized(),
            action: action,
            keyEquivalent: ""
        )
        item.target = self
        return item
    }

    private func showHomeItem() -> NSMenuItem {
        item(title: "home", action: #selector(showHome))
    }

    @objc func showHome() {
        MainScene.show()
    }
    
    private func hideAllPetsItem() -> NSMenuItem {
        item(title: "hideAllPet", action: #selector(hideAllPets))
    }

    @objc func hideAllPets() {
        onScreen.hide()
    }
    
    private func followMouseItem() -> NSMenuItem {
        item(title: "followMouse", action: #selector(toggleFollowMouse))
    }
    
    @objc func toggleFollowMouse() {
        if let mouseChaser = subject?.capability(for: MouseChaser.self) {
            mouseChaser.kill()
        } else {
            subject?.install(MouseChaser())
        }
    }
}
#else
class ShowsMenuOnRightClick: RightClickable {}
#endif
