//
// Pet Therapy.
//

import AppState
import Biosphere
import DesignSystem
import LaunchAtLogin
import SwiftUI
import Schwifty
import Tracking

struct MainWindow: Scene {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onWindow { window in
                    window.makeKeyAndOrderFront(nil)
                    window.title = "Desktop Pets"
                }
        }
    }
}

extension MainWindow {
    
    static func hide() {
        MainWindowDelegate.instance?.window?.close()
    }
    
    static func show() {
        if let currentWindow = MainWindowDelegate.instance?.window {
            currentWindow.makeKeyAndOrderFront(nil)
            return
        }
        showMainWindow()
        trackAppLaunched()
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
        AppState.global.mainWindowSize = window.frame.size
    }
    
    private static func trackAppLaunched() {
        let appState = AppState.global
        Tracking.didLaunchApp(
            gravityEnabled: appState.gravityEnabled,
            petSize: appState.petSize,
            launchAtLogin: LaunchAtLogin.isEnabled,
            selectedPet: appState.selectedPet
        )
    }
}

class MainWindowDelegate: NSObject, NSWindowDelegate {
    
    fileprivate static var instance: MainWindowDelegate?
    
    fileprivate weak var window: NSWindow?
    
    static func setup(for window: NSWindow) {
        let delegate = MainWindowDelegate()
        delegate.window = window
        window.delegate = delegate
        MainWindowDelegate.instance = delegate
        AppState.global.mainWindowSize = window.frame.size
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        AppState.global.mainWindowSize = frameSize
        return frameSize
    }
    
    func windowWillClose(_ notification: Notification) {
        Task { @MainActor in
            AppState.global.mainWindowFocused = false
            MainWindowDelegate.instance = nil
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        Task { @MainActor in
            AppState.global.mainWindowFocused = true
        }
    }
    
    func windowDidResignMain(_ notification: Notification) {
        Task { @MainActor in
            AppState.global.mainWindowFocused = false
        }
    }
}
