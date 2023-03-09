import LaunchAtLogin
import Schwifty
import SwiftUI

struct LaunchAtLoginSwitch: View {
    @EnvironmentObject var appConfig: AppConfig
    
    var launchAtLogin: Binding<Bool> = Binding {
        LaunchAtLogin.isEnabled
    } set: { newValue in
        LaunchAtLogin.isEnabled = newValue
    }
    
    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.launchAtLogin,
            value: launchAtLogin
        )
        .positioned(.leading)
    }
}
