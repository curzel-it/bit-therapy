import DesignSystem
import SwiftUI

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                Text("Coming soon")
            }
            .padding(.md)
        }
    }
}
