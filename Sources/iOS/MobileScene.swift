import Game
import Schwifty
import SwiftUI

struct MainScene: Scene {
    @StateObject var appState = AppState.global
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GameView(with: appState, initialSize: Screen.main.bounds.size)
                GameMenu()
            }
            .environmentObject(appState)
        }
    }
}
