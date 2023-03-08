import Schwifty
import SwiftUI
import Swinject

struct MacContentView: View {
    static let minSize = CGSize(square: 700)
    
    var body: some View {
        ContentView()
            .frame(minWidth: MacContentView.minSize.width)
            .frame(minHeight: MacContentView.minSize.height)
            .onWindow { window in
                AppWindowManager.shared.current = window
                AppWindowManager.shared.customize(window)
            }
            .environmentObject(appState())
    }
    
    private func appState() -> AppState {
        Container.main.resolve(AppState.self)!
    }
}
