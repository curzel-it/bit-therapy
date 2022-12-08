import DesignSystem
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                Text(Lang.Page.settings).title()
                RestorePurchasesButton()
            }
            .padding(.md)
        }
    }
}
