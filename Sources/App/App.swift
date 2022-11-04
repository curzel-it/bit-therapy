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

enum AppPage: String, CaseIterable {
    case about
    case home
    case none
    case settings
}

extension AppPage: CustomStringConvertible {
    var description: String {
        switch self {
        case .about: return Lang.Page.about
        case .home: return Lang.Page.home
        case .none: return ""
        case .settings: return Lang.Page.settings
        }
    }
}

extension AppPage {
    var icon: String {
        switch self {
        case .about: return "info.circle"
        case .home: return "circle.grid.3x3"
        case .none: return "questionmark.app"
        case .settings: return "gearshape"
        }
    }
}

