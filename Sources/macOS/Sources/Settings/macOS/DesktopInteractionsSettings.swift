import Schwifty
import SwiftUI

struct DesktopInteractionsSwitch: View {
    @EnvironmentObject private var appConfig: AppConfig
    
    @State private var showingDetails = false
    
    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.desktopInteractionsTitle,
            value: $appConfig.desktopInteractions,
            showHelp: $showingDetails
        )
        .sheet(isPresented: $showingDetails) {
            VStack(alignment: .center, spacing: .xl) {
                Text(Lang.Settings.desktopInteractionsTitle)
                    .font(.largeTitle)
                    .padding(.top)
                Text(Lang.Settings.desktopInteractionsMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                Button(Lang.cancel) { showingDetails = false }
                    .buttonStyle(.text)
            }
            .padding()
            .frame(width: 450)
        }
        .positioned(.leading)
    }
}
