//
// Pet Therapy.
//

import DesignSystem
import GameMode
import GameState
import Schwifty
import Squanch
import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appState: GameState
    
    var body: some View {
        GeometryReader { geo in
            GameView(frame: frame(from: geo))
                .foregroundColor(.label)
                .font(.regular, .md)
                .environmentObject(GameState.global)
                .ignoresSafeArea(.all, edges: .all)
        }
    }
    
    func frame(from geo: GeometryProxy) -> CGRect {
        CGRect(
            x: geo.safeAreaInsets.leading,
            y: geo.safeAreaInsets.top,
            width: geo.size.width,
            height: geo.size.height
        )
    }
}

extension GeometryProxy: Equatable {
    
    public static func == (lhs: GeometryProxy, rhs: GeometryProxy) -> Bool {
        return lhs.size == rhs.size && lhs.safeAreaInsets == rhs.safeAreaInsets
    }
}
