import Combine
import Schwifty
import SwiftUI
import Swinject

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onboardingHandler()
                .environmentObject(appConfig())
        }
    }
    
    private func appConfig() -> AppConfig {
        Container.main.resolve(AppConfig.self)!
    }
}
