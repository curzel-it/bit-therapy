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
        Tracking.setup()
    }

    var body: some Scene {
        MainScene()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @Inject private var appConfig: AppConfig
    @Inject private var onScreen: OnScreenCoordinator
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Logger.log("AppDelegate", "Did finish launching")
#if DEBUG
        let bgCommanyKey = "background="
        let bgCommand = CommandLine.arguments.first { $0.starts(with: bgCommanyKey) }
        if let bgName = bgCommand?.replacingOccurrences(of: bgCommanyKey, with: "") {
            appConfig.background = bgName
        }
#endif
        onScreen.show()
        return true
    }
}

