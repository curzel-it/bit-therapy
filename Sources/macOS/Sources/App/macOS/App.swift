import RateKit
import Schwifty
import SwiftUI

@main
struct MyApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        Dependencies.setup()
        Logger.isEnabled = true
        Logger.log("MyApp", "Init")
        Tracking.setup()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            RateKit.ratingsService(
                debug: true,
                launchesBeforeAskingForReview: 10
            ).askForRatingIfNeeded()
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            @Inject var onScreen: OnScreenCoordinator
            onScreen.show()
            StatusBarCoordinator.shared.show()
        }
    }

    var body: some Scene {
        MainScene()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("AppDelegate", "Did finish launching")
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        Logger.log("App", "Screen params changed, relaunching species...")
        @Inject var onScreen: OnScreenCoordinator
        onScreen.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            onScreen.show()
        }
    }
}

