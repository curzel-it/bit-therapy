import AppKit
import Schwifty

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("AppDelegate", "Did finish launching")
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        Logger.log("App", "Screen params changed, relaunching species...")
        OnScreenCoordinator.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnScreenCoordinator.show()
        }
    }
}
