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
    
    private let tag = "AppDelegate"
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Logger.log(tag, "Did finish launching")
        loadCommandLineBackground()
        loadCommandLinePets()
        onScreen.show()
        return true
    }
    
    private func loadCommandLineBackground() {
        let key = "background="
        let command = CommandLine.arguments.first { $0.starts(with: key) }
        guard let value = command?.replacingOccurrences(of: key, with: "") else { return }
        Logger.log(tag, "Loading background '\(value)' as per command line args")
        appConfig.background = value
    }
    
    private func loadCommandLinePets() {
        let key = "pets="
        let command = CommandLine.arguments.first { $0.starts(with: key) }
        guard let value = command?.replacingOccurrences(of: key, with: "") else { return }
        
        let species = value
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        Logger.log(tag, "Loading pets '\(species)' as per command line args")
        appConfig.replaceSelectedSpecies(with: species)
    }
}

