//
// Pet Therapy.
//

import DesignSystem
import SwiftUI
import Schwifty

struct MainWindow: Scene {
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    static func show() {
        if let currentWindow = MainWindowDelegate.instance?.window {
            currentWindow.makeKeyAndOrderFront(nil)
            return
        }
        showMainWindow()
    }
    
    static func hide() {
        MainWindowDelegate.instance?.window?.close()
    }
    
    private static func showMainWindow() {
        let view = NSHostingView(rootView: MainView())
        let window = NSWindow(
            contentRect: CGRect(
                x: 0, y: 0,
                width: 600,
                height: 600
            ),
            styleMask: [.resizable, .closable, .titled],
            backing: .buffered,
            defer: false
        )
        window.title = "Desktop Pets"
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        window.show()
    }
}

class MainWindowDelegate: NSObject, NSWindowDelegate {
    
    fileprivate static var instance: MainWindowDelegate?
    
    fileprivate weak var viewModel: PetSelectionViewModel?
    fileprivate weak var window: NSWindow?
    
    static func setup(for window: NSWindow, with vm: PetSelectionViewModel) {
        let delegate = MainWindowDelegate()
        delegate.viewModel = vm
        delegate.window = window
        window.delegate = delegate
        MainWindowDelegate.instance = delegate
    }
    
    func windowWillClose(_ notification: Notification) {
        Task { @MainActor in
            viewModel?.kill()
            MainWindowDelegate.instance = nil
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        Task { @MainActor in
            viewModel?.startRendering()
        }
    }
    
    func windowDidResignMain(_ notification: Notification) {
        Task { @MainActor in
            viewModel?.pauseRendering()
        }
    }
}
