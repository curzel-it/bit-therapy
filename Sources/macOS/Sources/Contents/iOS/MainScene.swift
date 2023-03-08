import Combine
import Schwifty
import SwiftUI
import Swinject

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onboardingHandler()
                .environmentObject(appState())
        }
    }
    
    private func appState() -> AppState {
        Container.main.resolve(AppState.self)!
    }
}
