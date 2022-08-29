import AppState
import DesignSystem
import InAppPurchases
import Lang
import LaunchAtLogin
import OnScreen
import SwiftUI
import Tracking

// MARK: - Settings

struct SettingsView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: .xl) {
            SizeSlider()
            GravitySwitch().positioned(.leading)
            DesktopInteractions().positioned(.leading)
            LaunchAtLoginSwitch().positioned(.leading)
            StatusBarIconSwitch().positioned(.leading)
            AnonymousTracking().positioned(.leading)
            FixOnScreenPets().positioned(.leading)
            RestorePurchasesButton().positioned(.leading)
        }
        .padding(.md)
    }
}

// MARK: - Reset

private struct FixOnScreenPets: View {
    
    var body: some View {
        Button(Lang.PetSelection.fixOnScreenPets) { OnScreen.show() }
            .buttonStyle(.regular)
    }
}

// MARK: - Gravity

private struct GravitySwitch: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Switch(Lang.Settings.gravity, $appState.gravityEnabled)
    }
}

// MARK: - Desktop Interactions

private struct DesktopInteractions: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var showingDetails = false
    
    var body: some View {
        HStack(spacing: .sm) {
            Switch(Lang.Settings.desktopInteractions, appState.$desktopInteractions)
            Image(systemName: "info.circle.fill")
                .font(.title)
                .onTapGesture {
                    showingDetails = true
                }
        }
        .sheet(isPresented: $showingDetails) {
            VStack(alignment: .center, spacing: .xl) {
                Text(Lang.Settings.desktopInteractions)
                    .font(.largeTitle)
                    .padding(.top)
                Text(Lang.Settings.desktopInteractionsMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                HStack {
                    Button(Lang.enable) {
                        appState.desktopInteractions = true
                        showingDetails = false
                    }
                    .buttonStyle(.regular)
                    Spacer()
                    Button(Lang.cancel) { showingDetails = false }
                        .buttonStyle(.text)
                }
            }
            .padding()
            .frame(width: 450)
        }
    }
}

// MARK: - Anonymous Tracking

private struct AnonymousTracking: View {
    
    @State var showingDetails = false
    
    var enabled: Binding<Bool> = Binding {
        AppState.global.trackingEnabled
    } set: { isEnabled in
        AppState.global.trackingEnabled = isEnabled
        Tracking.isEnabled = isEnabled
    }
    
    var body: some View {
        HStack(spacing: .sm) {
            Switch(Lang.Settings.anonymousTracking, enabled)
            Image(systemName: "info.circle.fill")
                .font(.title)
                .onTapGesture {
                    showingDetails = true
                }
        }
        .sheet(isPresented: $showingDetails) {
            VStack(alignment: .center, spacing: .xl) {
                Text(Lang.Settings.anonymousTrackingExplainedTitle)
                    .font(.largeTitle)
                    .padding(.top)
                Text(Lang.Settings.anonymousTrackingExplained)
                    .font(.body)
                    .multilineTextAlignment(.center)
                HStack {
                    Button(Lang.cancel) { showingDetails = false }
                        .buttonStyle(.text)
                    Spacer()
                    PrivacyPolicy()
                }
            }
            .padding()
            .frame(width: 450)
        }
    }
}

// MARK: - Show in Menu Bar

private struct StatusBarIconSwitch: View {
    
    var enabled: Binding<Bool> = Binding {
        AppState.global.statusBarIconEnabled
    } set: { isEnabled in
        AppState.global.statusBarIconEnabled = isEnabled
        Task { @MainActor in
            if isEnabled {
                StatusBarItems.main.setup()
            } else {
                StatusBarItems.main.remove()
            }
        }
    }
    
    var body: some View {
        Switch(Lang.Settings.statusBarIconEnabled, enabled)
    }
}

// MARK: - Launch At Login

private struct LaunchAtLoginSwitch: View {
    
    @EnvironmentObject var appState: AppState
    
    var launchAtLogin: Binding<Bool> = Binding {
        LaunchAtLogin.isEnabled
    } set: { newValue in
        LaunchAtLogin.isEnabled = newValue
    }
    
    var body: some View {
        Switch(Lang.Settings.launchAtLogin, launchAtLogin)
    }
}

// MARK: - Pet Size

private struct SizeSlider: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: .md) {
            Text("\(Lang.Settings.size) (\(Int(appState.petSize)))")
                .textAlign(.leading)
                .frame(width: 100)
            Slider(
                value: $appState.petSize,
                in: PetSize.minSize...PetSize.maxSize
            ) { EmptyView() }
        }
    }
}

// MARK: - Utils

private struct Switch: View {
    
    let label: String
    let value: Binding<Bool>
    
    init(_ label: String, _ value: Binding<Bool>) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        Toggle(label, isOn: value).toggleStyle(.switch)
    }
}
