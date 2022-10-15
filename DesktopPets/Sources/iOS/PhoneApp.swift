import AppState
import InAppPurchases
import Schwifty
import Squanch
import SwiftUI
import Tracking

@main
struct MyApp: App {
    
    // swiftlint:disable:next weak_delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        Tracking.setup(isEnabled: AppState.global.trackingEnabled)
        PricingService.global.setup()
        Cheats.enableCheats()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        printDebug("App", "Launched")
    }
}
