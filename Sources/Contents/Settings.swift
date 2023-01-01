import DesignSystem
import LaunchAtLogin
import OnScreen
import Schwifty
import SwiftUI
import Tracking

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                VStack(spacing: .lg) {
                    SizeSlider()
                    SpeedSlider()
                    Switches()
                }
                FixOnScreenPets().positioned(.leading)
                ScreensOnOffSettings()
                CheatsView().positioned(.leading)
            }
            .padding(.md)
        }
    }
}

private struct Switches: View {
    var body: some View {
        HStack {
            VStack(spacing: .lg) {
                GravitySwitch().positioned(.leading)
                DesktopInteractionsSwitch().positioned(.leading)
                LaunchAtLoginSwitch().positioned(.leading)
            }
            Spacer()
            VStack(spacing: .lg) {
                StatusBarIconSwitch().positioned(.leading)
                AnonymousTrackingSwitch().positioned(.leading)
            }
        }
    }
}

// MARK: - Multiple Screens

private struct ScreensOnOffSettings: View {
    @State var isOn = true
    
    var body: some View {
        VStack {
            Text(Lang.Settings.enabledDisplays).font(.title3.bold()).textAlign(.leading)
            ForEach(NSScreen.screens) {
                ScreenSwitch(screen: $0).positioned(.leading)
            }
        }
        .positioned(.leading)
    }
}

private struct ScreenSwitch: View {
    class ViewModel: ObservableObject {
        let screen: NSScreen
        
        @Published var isEnabled: Bool {
            didSet {
                AppState.global.set(screen: screen, enabled: isEnabled)
                OnScreenCoordinator.show(with: AppState.global, assets: PetsAssetsProvider.shared)
            }
        }
        
        init(screen: NSScreen) {
            self.screen = screen
            self.isEnabled = AppState.global.isEnabled(screen: screen)
        }
    }
    
    @StateObject var viewModel: ViewModel
    
    init(screen: NSScreen) {
        _viewModel = StateObject(wrappedValue: ViewModel(screen: screen))
    }
    
    var body: some View {
        Toggle(viewModel.screen.localizedName, isOn: $viewModel.isEnabled)
    }
}

// MARK: - Desktop Interactions

private struct DesktopInteractionsSwitch: View {
    @EnvironmentObject var appState: AppState

    @State var showingDetails = false

    var body: some View {
        HStack(spacing: .sm) {
            SettingsSwitch(
                label: Lang.Settings.desktopInteractionsTitle,
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
                Text(Lang.Settings.desktopInteractionsTitle)
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

private struct AnonymousTrackingSwitch: View {
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
                Text(Lang.Settings.anonymousTrackingTitle)
                    .font(.largeTitle)
                    .padding(.top)
                Text(Lang.Settings.anonymousTrackingMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Button(Lang.cancel) { showingDetails = false }
                    .buttonStyle(.text)
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
            OnScreenCoordinator.show(with: AppState.global, assets: PetsAssetsProvider.shared)
        }
        .buttonStyle(.regular)
    }
}

// MARK: - Gravity

struct GravitySwitch: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.gravity,
            value: $appState.gravityEnabled
        )
    }
}

// MARK: - Pet Size

struct SizeSlider: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        SettingsSlider(
            label: "\(Lang.Settings.size) (\(Int(appState.petSize)))",
            value: $appState.petSize,
            range: PetSize.minSize ... PetSize.maxSize,
            reset: { appState.petSize = PetSize.defaultSize }
        )
    }
}

// MARK: - Pet Speed Multiplier

struct SpeedSlider: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        SettingsSlider(
            label: "\(Lang.Settings.speed) (\(Int(appState.speedMultiplier * 100))%)",
            value: $appState.speedMultiplier,
            range: 0.25 ... 2,
            reset: { appState.speedMultiplier = 1.0 }
        )
    }
}

// MARK: - Utils

struct SettingsSwitch: View {
    let label: String
    let value: Binding<Bool>

    var body: some View {
        Toggle(label, isOn: value).toggleStyle(.switch)
    }
}

struct SettingsSlider: View {
    let label: String
    let value: Binding<CGFloat>
    let range: ClosedRange<CGFloat>
    let reset: () -> Void

    var axis: Axis.Set {
        DeviceRequirement.iPhone.isSatisfied ? .vertical : .horizontal
    }

    var body: some View {
        VHStack(axis, spacing: Spacing.md.rawValue) {
            Text(label)
                .textAlign(.leading)
                .frame(width: 100, when: .macOS)

            Slider(value: value, in: range) { EmptyView() }
                .frame(width: 300, when: .iPad)

            Button(Lang.reset) { reset() }
                .buttonStyle(.text)
                .positioned(.trailing, when: .iOS)
        }
    }
}

public struct VHStack<Content: View>: View {
    let content: () -> Content
    let isHorizontal: Bool
    let spacing: CGFloat?

    public init(
        _ axis: Axis.Set,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        isHorizontal = axis.contains(.horizontal)
        self.spacing = spacing
    }

    public var body: some View {
        ZStack {
            if isHorizontal {
                HStack(spacing: spacing) { content() }
            } else {
                VStack(spacing: spacing) { content() }
            }
        }
    }
}
