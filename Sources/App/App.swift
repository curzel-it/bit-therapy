import RateKit
import Schwifty
import SwiftUI
import Yage

@main
struct MyApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        Logger.isEnabled = true
        Tracking.setup(isEnabled: AppState.global.trackingEnabled)
        CapabilitiesDiscoveryService.shared = PetsCapabilitiesDiscoveryService()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            RateKit.ratingsService(
                debug: AppState.global.isDevApp,
                launchesBeforeAskingForReview: 10
            ).askForRatingIfNeeded()
        }
    }

    var body: some Scene {
        MainScene()
    }
}
