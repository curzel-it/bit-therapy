// 
// Pet Therapy.
// 

import Combine
import Physics
import Schwifty
import SwiftUI

struct OnScreenWindow {
    
    static var isShown: Bool { OnScreenWindowManager.instance != nil }
    
    static func show(for pet: Pet? = nil, onlyIfNeeded: Bool = false) {
        guard !onlyIfNeeded || !isShown else { return }
        let viewModel = OnScreenViewModel(for: pet)
        let window = buildWindow()
        let view = HostView(viewModel: viewModel)        
        OnScreenWindowManager.setup(with: viewModel, view: view, window: window)
    }
    
    static func hide() {
        OnScreenWindowManager.instance?.kill()
    }
    
    private static func buildWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: CGRect(origin: .zero, size: .zero),
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.hasShadow = false
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        window.level = .statusBar
        window.collectionBehavior = .canJoinAllSpaces
        return window
    }
}
