import Game
import SwiftUI

class GameCoordinator {
    static func show(with appState: AppState) {
        let size = CGSize(square: 600)
        let view = NSHostingView(rootView: GameView(with: appState, initialSize: size))
        let window = NSWindow(
            contentRect: CGRect(size: size),
            styleMask: [.closable, .titled, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Desktop Pets"
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        window.show()
    }
}
