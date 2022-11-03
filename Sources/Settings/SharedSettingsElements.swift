import DesignSystem
import InAppPurchases
import Schwifty
import SwiftUI
import Tracking

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
            range: PetSize.minSize...PetSize.maxSize,
            reset: { appState.petSize = PetSize.defaultSize }
        )
        /*
         HStack(spacing: .md) {
         Text("\(Lang.Settings.size) (\(Int(appState.petSize)))")
         .textAlign(.leading)
         .frame(width: 100)
         Slider(
         value: $appState.petSize,
         in: PetSize.minSize...PetSize.maxSize
         ) { EmptyView() }
         
         Button(Lang.reset) { appState.petSize = PetSize.defaultSize }
         .buttonStyle(.text)
         }*/
    }
}

// MARK: - Pet Speed Multiplier

struct SpeedSlider: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        SettingsSlider(
            label: "\(Lang.Settings.speed) (\(Int(appState.speedMultiplier * 100))%)",
            value: $appState.speedMultiplier,
            range: 0.25...2,
            reset: { appState.speedMultiplier = 1.0 }
        )
        /*
         HStack(spacing: .md) {
         Text("\(Lang.Settings.speed) (\(Int(appState.speedMultiplier * 100))%)")
         .textAlign(.leading)
         .frame(width: 100)
         Slider(
         value: $appState.speedMultiplier,
         in: 0.25...2
         ) { EmptyView() }
         
         Button(Lang.reset) { appState.speedMultiplier = 1.0 }
         .buttonStyle(.text)
         }*/
    }
}

// MARK: - In-App Purchases

struct RestorePurchasesButton: View {
    var body: some View {
        InAppPurchases.RestorePurchasesButton(with: Localized())
            .positioned(.leading)
    }
    
    struct Localized: InAppPurchases.Lang {
        var done: String { Lang.done }
        var loading: String { Lang.loading }
        var restorePurchases: String { Lang.Settings.restorePurchases }
        var somethingWentWrong: String { Lang.somethingWentWrong }
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
                .frame(minWidth: 200)
            
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
        self.isHorizontal = axis.contains(.horizontal)
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
