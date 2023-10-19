import Schwifty
import SwiftUI

struct LaunchSilentlySwitch: View {
    @EnvironmentObject private var appConfig: AppConfig
    
    @State private var showingDetails = false
    
    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.launchSilentlyTitle,
            value: $appConfig.launchSilently,
            showHelp: $showingDetails
        )
        .sheet(isPresented: $showingDetails) {
            VStack(alignment: .center, spacing: .xl) {
                Text(Lang.Settings.launchSilentlyTitle)
                    .font(.largeTitle)
                    .padding(.top)
                Text(Lang.Settings.launchSilentlyMessage)
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
