import RateKit
import Schwifty
import SwiftUI
import Yage

@main
struct MyApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        Dependencies.setup()
        Logger.isEnabled = true
        Tracking.setup()
        CapabilitiesDiscoveryService.shared = PetsCapabilitiesDiscoveryService()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            RateKit.ratingsService(
                debug: true,
                launchesBeforeAskingForReview: 10
            ).askForRatingIfNeeded()
        }
    }

    var body: some Scene {
        MainScene()
    }
}
