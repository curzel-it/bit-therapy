import InAppPurchases
import OnScreen
import RateKit
import Schwifty
import Squanch
import SwiftUI
import Tracking

@main
struct MyApp: App {
    
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        Tracking.setup(isEnabled: AppState.global.trackingEnabled)
        PricingService.global.setup()
        Cheats.enableCheats()
        Task { @MainActor in
            OnScreen.show(with: AppState.global)
            StatusBarItems.main.setup()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            RateKit.ratingsService(
                debug: true,
                launchesBeforeAskingForReview: 2
            ).askForRatingIfNeeded()
        }
    }
    
    var body: some Scene {
        MainWindow()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        printDebug("App", "Launched")
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        printDebug("App", "Screen params changed, relaunching pets...")
        OnScreen.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnScreen.show(with: AppState.global)
        }
    }
}
