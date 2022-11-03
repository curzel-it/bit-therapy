import InAppPurchases
import RateKit
import Schwifty
import Squanch
import SwiftUI
import Tracking
import UIKit

@main
struct MobileApp: App {
    // swiftlint:disable:next weak_delegate
    
    init() {
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

