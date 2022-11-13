import Game
import Schwifty
import SwiftUI

struct MainScene: Scene {
    @StateObject var appState = AppState.global
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GameCoordinator.view(with: appState)
                GameMenu()
            }
            .environmentObject(appState)
        }
    }
}

private class GameCoordinator {
    static func view(with appState: AppState) -> some View {
        Game.Coordinator.view(
            with: appState,
            initialSize: Screen.main.bounds.size,
            localizedContent: LocalizedContent()
        )
    }
}

private struct LocalizedContent: LocalizedContentProvider {
    var close: String { Lang.Game.introClose }
    var desktopApp: String { Lang.Game.desktopApp }
    var intro: String { Lang.Game.intro }
    var introComplete: String { Lang.Game.introComplete }
}
