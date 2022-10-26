import AppState
import DesignSystem
import LaunchAtLogin
import OnWindow
import SwiftUI
import Schwifty
import Tracking

struct MainWindow: Scene {    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AppState.global)
        }
    }
}

extension MainWindow {
    static func show() {
        showMainWindow()
        trackAppLaunched()
    }
    
    private static func showMainWindow() {
        let view = NSHostingView(rootView: MainView())
        let window = NSWindow(
            contentRect: CGRect(x: 400, y: 200, width: 600, height: 600),
            styleMask: [.resizable, .closable, .titled],
            backing: .buffered,
            defer: false
        )
        window.title = "Desktop Pets"
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        window.show()
    }
    
    private static func trackAppLaunched() {
        let appState = AppState.global
        Tracking.didLaunchApp(
            gravityEnabled: appState.gravityEnabled,
            petSize: appState.petSize,
            launchAtLogin: LaunchAtLogin.isEnabled,
            selectedPets: appState.selectedPets
        )
    }
}
