import AppKit
import OnScreen
import Schwifty
import Yage

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("App", "Launched")
        OnScreenCoordinator.show(with: AppState.global, assets: PetsAssetsProvider.shared)
        StatusBarCoordinator.shared.show()
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        Logger.log("App", "Screen params changed, relaunching species...")
        OnScreenCoordinator.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnScreenCoordinator.show(with: AppState.global, assets: PetsAssetsProvider.shared)
        }
    }
}

extension AppState: DesktopSettings {}
