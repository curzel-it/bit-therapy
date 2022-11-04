import DesignSystem
import SwiftUI

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                Text(Lang.Page.settings).title()
                SizeSlider()
                SpeedSlider()
                GravitySwitch().positioned(.leading)
                RestorePurchasesButton()
                CheatsView().positioned(.leading)
            }
            .padding(.md)
        }
    }
}
