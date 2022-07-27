// 
// Pet Therapy.
//

import DesignSystem
import GameMode
import GameState
import OnWindow
import Schwifty
import Squanch
import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appState: GameState
    
    var fullScreen: CGRect {
        (NSScreen.main ?? NSScreen.screens.first)?.frame ?? .zero
    }
    
    var body: some View {
        GameView(frame: fullScreen)
            .foregroundColor(.label)
            .font(.regular, .md)
            .environmentObject(GameState.global)
            .ignoresSafeArea(.all, edges: .all)
            .onWindow { window in
                MainWindowDelegate.setup(for: window)
            }
    }
}

