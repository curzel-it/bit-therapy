import LaunchAtLogin
import Schwifty
import SwiftUI

struct ScreensOnOffSettings: View {
    @State var isOn = true
    
    var body: some View {
        VStack {
            Text(Lang.Settings.enabledDisplays).font(.title3.bold()).textAlign(.leading)
            ForEach(Screen.screens) {
                ScreenSwitch(screen: $0).positioned(.leading)
            }
        }
        .positioned(.leading)
    }
}

private struct ScreenSwitch: View {
    @StateObject var viewModel: ViewModel
    
    init(screen: Screen) {
        _viewModel = StateObject(wrappedValue: ViewModel(screen: screen))
    }
    
    var body: some View {
        Toggle(viewModel.screen.localizedName, isOn: $viewModel.isEnabled)
    }
}

private class ViewModel: ObservableObject {
    @Inject private var appState: AppState
    @Inject private var onScreen: OnScreenCoordinator
    
    let screen: Screen
    
    @Published var isEnabled: Bool {
        didSet {
            appState.set(screen: screen, enabled: isEnabled)
            onScreen.show()
        }
    }
    
    init(screen: Screen) {
        @Inject var appState: AppState
        self.screen = screen
        self.isEnabled = appState.isEnabled(screen: screen)
    }
}

struct DesktopInteractionsSwitch: View {
    @EnvironmentObject var appState: AppState
    
    @State var showingDetails = false
    
    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.desktopInteractionsTitle,
            value: $appState.desktopInteractions,
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

struct LaunchAtLoginSwitch: View {
    @EnvironmentObject var appState: AppState
    
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
