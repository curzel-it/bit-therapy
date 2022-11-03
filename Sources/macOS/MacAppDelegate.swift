import AppKit
import OnScreen
import Squanch

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        printDebug("App", "Launched")        
        OnScreen.show(with: AppState.global)
        StatusBarCoordinator.shared.show()
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        printDebug("App", "Screen params changed, relaunching pets...")
        OnScreen.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnScreen.show(with: AppState.global)
        }
    }
}

extension AppState: OnScreenSettings {}
