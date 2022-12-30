import Pets
import RateKit
import Schwifty
import SwiftUI
import Tracking

@main
struct MyApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        Logger.isEnabled = AppState.global.isDevApp
        Tracking.setup(isEnabled: AppState.global.trackingEnabled)
        Cheats.enableCheats()
        PetEntity.assetsProvider = PetsAssetsProvider.shared
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

extension PetsAssetsProvider: Pets.AssetsProvider {}
