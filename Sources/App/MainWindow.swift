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
        window.makeKeyAndOrderFront(nil)
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
    
    fileprivate weak var viewModel: HabitatViewModel?
    fileprivate weak var window: NSWindow?
    
    static func setup(for window: NSWindow, with vm: HabitatViewModel) {
        let delegate = MainWindowDelegate()
        delegate.viewModel = vm
        delegate.window = window
        window.delegate = delegate
        MainWindowDelegate.instance = delegate
    }
    
    func windowWillClose(_ notification: Notification) {
        Task { @MainActor in
            viewModel?.kill(animated: false)
            MainWindowDelegate.instance = nil
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) { startRendering() }
    func windowDidResignMain(_ notification: Notification) { pauseRendering() }
    func windowDidBecomeKey(_ notification: Notification) { startRendering()  }
    func windowDidResignKey(_ notification: Notification) { pauseRendering() }
    
    func startRendering() {
        Task { @MainActor in
            viewModel?.startRendering()
        }
    }
    
    func pauseRendering() {
        Task { @MainActor in
            viewModel?.pauseRendering()
        }
    }
}
