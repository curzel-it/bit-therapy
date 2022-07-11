// 
// Pet Therapy.
//

import GameState
import DesignSystem
import GameMode
import SwiftUI
import Schwifty

struct MainView: View {
    
    @EnvironmentObject var appState: GameState

    let size: CGSize
    
    var body: some View {
        GameView(size: size)
            .foregroundColor(.label)
            .font(.regular, .md)
            .environmentObject(GameState.global)
    }
}
