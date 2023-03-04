import Schwifty
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                if DeviceRequirement.iOS.isSatisfied {
                    Text(Lang.Page.settings).font(.boldTitle).positioned(.leading)
                }
                Switches()
                ScreensOnOffSettings()
                BackgroundSettings()
                FixOnScreenPets().positioned(.leading)
            }
            .padding(.md)
        }
    }
}

private struct Switches: View {
    var body: some View {
        VStack(spacing: .lg) {
            SizeControl()
            SpeedControl()
            LaunchAtLoginSwitch()
            GravitySwitch()
            DesktopInteractionsSwitch()
            RandomEventsSwitch()
        }
    }
}

// MARK: - Reset

struct FixOnScreenPets: View {
    var body: some View {
        Button(Lang.PetSelection.fixOnScreenPets) {
            @Inject var onScreen: OnScreenCoordinator
            onScreen.show()
        }
        .buttonStyle(.regular)
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
        .positioned(.leading)
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
        .positioned(.leading)
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
                Image(systemName: "info.circle")
                    .font(.title)
                    .onTapGesture {
                        showHelp.wrappedValue = true
                    }
            }
            Spacer()
        }
    }
}
