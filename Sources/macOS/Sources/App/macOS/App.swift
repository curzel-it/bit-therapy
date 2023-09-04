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
    }

    var body: some Scene {
        MainScene()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    @Inject private var commandLine: CommandLineUseCase
    @Inject private var notifications: NotificationsService
    @Inject private var onScreen: OnScreenCoordinator
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("AppDelegate", "Did finish launching")
        commandLine.handleCommandLineArgs()
        notifications.start()
        NSApp.setActivationPolicy(.accessory)
        startApp()
        scheduleAskForRatingIfNeeded()
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        Logger.log("App", "Screen params changed, relaunching species...")
        onScreen.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.onScreen.show()
        }
    }
    
    private func startApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.onScreen.show()
            StatusBarCoordinator.shared.show()
        }
    }
    
    private func scheduleAskForRatingIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            RateKit.ratingsService(debug: true, launchesBeforeAskingForReview: 10)
                .askForRatingIfNeeded()
        }
    }
}

