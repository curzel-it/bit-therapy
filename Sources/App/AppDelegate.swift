import AppKit
import Schwifty
import Yage

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("App", "Launched")
        OnScreenCoordinator.show()
        StatusBarCoordinator.shared.show()
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        Logger.log("App", "Screen params changed, relaunching species...")
        OnScreenCoordinator.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnScreenCoordinator.show()
        }
    }
}
