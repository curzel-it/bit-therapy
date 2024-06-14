import SwiftUI

struct MenuBarSwitch: View {
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.statusBarIconEnabled,
            value: $appConfig.showInMenuBar
        )
        .positioned(.leading)
    }
}
