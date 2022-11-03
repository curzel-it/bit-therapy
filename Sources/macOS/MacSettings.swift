import DesignSystem
import InAppPurchases
import SwiftUI
import Tracking
import LaunchAtLogin
import OnScreen

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                SizeSlider()
                SpeedSlider()
                GravitySwitch().positioned(.leading)
                DesktopInteractions().positioned(.leading)
                LaunchAtLoginSwitch().positioned(.leading)
                StatusBarIconSwitch().positioned(.leading)
                AnonymousTracking().positioned(.leading)
                FixOnScreenPets().positioned(.leading)
                RestorePurchasesButton()
                CheatsView().positioned(.leading)
            }
            .padding(.md)
        }
    }
}

// MARK: - Desktop Interactions

private struct DesktopInteractions: View {
    @EnvironmentObject var appState: AppState
    
    @State var showingDetails = false
    
    var body: some View {
        HStack(spacing: .sm) {
            SettingsSwitch(
                label: Lang.Settings.desktopInteractions,
                value: $appState.desktopInteractions
            )
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
            SettingsSwitch(label: Lang.Settings.anonymousTracking, value: enabled)
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
        AppState.global.showInMenuBar
    } set: { isEnabled in
        AppState.global.showInMenuBar = isEnabled
        Task { @MainActor in
            if isEnabled {
                StatusBarCoordinator.shared.show()
            } else {
                StatusBarCoordinator.shared.hide()
            }
        }
    }
    
    var body: some View {
        SettingsSwitch(label: Lang.Settings.statusBarIconEnabled, value: enabled)
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
        SettingsSwitch(label: Lang.Settings.launchAtLogin, value: launchAtLogin)
    }
}

// MARK: - Reset

private struct FixOnScreenPets: View {
    var body: some View {
        Button(Lang.PetSelection.fixOnScreenPets) {
            OnScreen.show(with: AppState.global)
        }
        .buttonStyle(.regular)
    }
}
