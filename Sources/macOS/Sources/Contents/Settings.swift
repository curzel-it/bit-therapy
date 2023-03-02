import DesignSystem
import LaunchAtLogin
import Schwifty
import SwiftUI

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                VStack(spacing: .lg) {
                    SizeControl()
                    SpeedControl()
                    Switches()
                }
                FixOnScreenPets().positioned(.leading)
                ScreensOnOffSettings()
            }
            .padding(.md)
        }
    }
}

private struct Switches: View {
    var body: some View {
        VStack(spacing: .lg) {
            LaunchAtLoginSwitch().positioned(.leading)
            GravitySwitch().positioned(.leading)
            DesktopInteractionsSwitch().positioned(.leading)
            RandomEventsSwitch().positioned(.leading)
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
                OnScreenCoordinator.show()
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
    }
}

// MARK: - Random Events

private struct RandomEventsSwitch: View {
    @EnvironmentObject var appState: AppState
    
    @State var showingDetails = false
    
    var body: some View {
        SettingsSwitch(
            label: Lang.Settings.randomEventsTitle,
            value: $appState.randomEvents,
            showHelp: $showingDetails
        )
        .sheet(isPresented: $showingDetails) {
            VStack(alignment: .center, spacing: .xl) {
                Text(Lang.Settings.randomEventsTitle)
                    .font(.largeTitle)
                    .padding(.top)
                Text(Lang.Settings.randomEventsMessage)
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
            OnScreenCoordinator.show()
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

struct SizeControl: View {
    @EnvironmentObject var appState: AppState
    
    @State var text: String = ""
    
    var formattedValue: String {
        "\(Int(appState.petSize))"
    }
    
    var body: some View {
        HStack {
            Text(Lang.Settings.size).textAlign(.leading).frame(width: 150)
            TextField(formattedValue, text: $text).frame(width: 100)
            Spacer()
        }
        .onChange(of: text) { newText in
            guard let value = Float(newText) else { return }
            let newSize = max(min(CGFloat(value), PetSize.maxSize), PetSize.minSize)
            guard appState.petSize != newSize else { return }
            appState.petSize = newSize
        }
    }
}

// MARK: - Pet Speed Multiplier

struct SpeedControl: View {
    @EnvironmentObject var appState: AppState
    
    @State var text: String = ""
    
    var formattedValue: String {
        "\(Int(AppState.global.speedMultiplier * 100))%"
    }
    
    var body: some View {
        HStack {
            Text(Lang.Settings.speed).textAlign(.leading).frame(width: 150)
            TextField(formattedValue, text: $text).frame(width: 100)
            Spacer()
        }
        .onChange(of: text) { newText in
            guard let value = Int(newText) else { return }
            let newSpeed = CGFloat(value) / 100
            guard appState.speedMultiplier != newSpeed else { return }
            guard 0 <= newSpeed && newSpeed <= 3 else { return }
            appState.speedMultiplier = newSpeed
        }
    }
}

// MARK: - Utils

struct SettingsSwitch: View {
    let label: String
    let value: Binding<Bool>
    var showHelp: Binding<Bool>?
    
    var body: some View {
        HStack {
            Text(label).textAlign(.leading).frame(width: 150)
            Toggle("", isOn: value).toggleStyle(.switch)
            if let showHelp {
                Image(systemName: "info.circle.fill")
                    .font(.title)
                    .onTapGesture {
                        showHelp.wrappedValue = true
                    }
            }
            Spacer()
        }
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
                .frame(width: 100)
            
            Slider(value: value, in: range) { EmptyView() }
            
            Button(Lang.reset) { reset() }
                .buttonStyle(.text)
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
