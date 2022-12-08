import AppKit
import OnScreen
import Schwifty

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("App", "Launched")
        OnScreen.show(with: AppState.global)
        StatusBarCoordinator.shared.show()
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        Logger.log("App", "Screen params changed, relaunching species...")
        OnScreen.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnScreen.show(with: AppState.global)
        }
    }
}

extension AppState: OnScreenSettings {}
