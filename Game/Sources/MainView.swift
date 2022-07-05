// 
// Pet Therapy.
//

import GameState
import DesignSystem
import GameMode
import Lang
import SwiftUI
import Schwifty

struct MainView: View {
    
    @EnvironmentObject var appState: GameState
    
    var body: some View {
        GameView()
            .frame(minWidth: 600)
            .frame(minHeight: 600)
            .foregroundColor(.label)
            .font(.regular, .md)
            .environmentObject(GameState.global)
            .onWindow { MainWindowDelegate.setup(for: $0) }
    }
}
