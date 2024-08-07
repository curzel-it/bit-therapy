import Schwifty
import SwiftUI

@main
struct MyApp: App {
    // swiftlint:disable:next weak_delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        Dependencies.setup()
        Logger.isEnabled = true
        Logger.log("MyApp", "Init")
    }

    var body: some Scene {
        MainScene()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @Inject private var commandLine: CommandLineUseCase
    @Inject private var onScreen: OnScreenCoordinator
    @Inject private var remoteConfig: RemoteConfigProvider

    private let tag = "AppDelegate"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Logger.log(tag, "Did finish launching")
        remoteConfig.fetch()
        commandLine.handleCommandLineArgs()
        onScreen.show()
        return true
    }
}
