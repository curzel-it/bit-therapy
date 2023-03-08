import Combine
import Schwifty
import SwiftUI

struct MainScene: Scene {
    @StateObject var appState = AppState.global
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onboardingHandler()
                .environmentObject(appState)
        }
    }
}
