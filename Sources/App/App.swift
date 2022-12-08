import InAppPurchases
import RateKit
import Schwifty
import SwiftUI
import Tracking

@main
struct MyApp: App {
    // swiftlint:disable:next weak_delegate
    #if os(macOS)
        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    init() {
        Logger.isEnabled = AppState.global.isDevApp
        Tracking.setup(isEnabled: AppState.global.trackingEnabled)
        PricingService.global.setup()
        Cheats.enableCheats()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            RateKit.ratingsService(
                debug: true,
                launchesBeforeAskingForReview: 2
            ).askForRatingIfNeeded()
        }
    }

    var body: some Scene {
        MainScene()
    }
}
