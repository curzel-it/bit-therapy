import Schwifty
import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        if viewModel.showStartAtLoginAlert {
            NewsBanner(
                title: Lang.Settings.launchAtLogin,
                message: Lang.Settings.launchAtLoginPromo,
                actions: [
                    .init(title: Lang.no, style: .text, action: viewModel.disableLaunchAtLogin),
                    .init(title: Lang.yes, style: .regular, action: viewModel.enableLaunchAtLogin)
                ]
            )
            .padding(.bottom, .xxl)
        }
        if viewModel.showBreakingChangesForVersion240 {
            NewsBanner(
                title: Lang.CustomPets.breakingChanges240Title,
                message: Lang.CustomPets.breakingChanges240Message,
                actions: [
                    .init(title: Lang.ok, style: .text) { viewModel.showBreakingChangesForVersion240 = false },
                        .init(title: Lang.CustomPets.readTheDocs, style: .regular, action: viewModel.showCustomPetsDocs)
                ]
            )
            .padding(.bottom, .xxl)
        }
    }
}

private class NewsViewModel: ObservableObject {
    @Inject private var launchAtLogin: LaunchAtLoginUseCase
    @Inject private var speciesProvider: SpeciesProvider
    
    @Published var showStartAtLoginAlert: Bool = false
    @Published var showBreakingChangesForVersion240: Bool = false
    
    @AppStorage("didShowLaunchAtLoginAlert") private var didShowLaunchAtLoginAlert = false
    @AppStorage("didShowBreakingChangesForVersion240") private var didShowBreakingChangesForVersion240 = false
    
    init() {
        showStartAtLoginAlert = !didShowLaunchAtLoginAlert && launchAtLogin.isAvailable && !launchAtLogin.isEnabled
        if showStartAtLoginAlert {
            didShowLaunchAtLoginAlert = true
        }
        showBreakingChangesForVersion240 = !didShowBreakingChangesForVersion240 && hasAnyCustomPets()
        didShowBreakingChangesForVersion240 = true
    }
    
    private func hasAnyCustomPets() -> Bool {
        speciesProvider.hasAnyCustomPets()
    }
    
    func showCustomPetsDocs() {
        URL(string: Lang.Urls.customPetsDocs)?.visit()
    }
    
    func enableLaunchAtLogin() {
        launchAtLogin.enable()
        withAnimation {
            showStartAtLoginAlert = false
        }
    }
    
    func disableLaunchAtLogin() {
        launchAtLogin.disable()
        withAnimation {
            showStartAtLoginAlert = false
        }
    }
}

private struct NewsBannerAction: Identifiable {
    let id = UUID().uuidString
    let title: String
    let style: CustomButtonStyle
    var action: () -> Void
}

private struct NewsBanner: View {
    let title: String
    let message: String
    let actions: [NewsBannerAction]
    
    var body: some View {
        VHStack(DeviceRequirement.iPhone.isSatisfied ? .vertical : .horizontal) {
            VStack(spacing: .md) {
                Text(title).font(.headline).textAlign(.leading)
                Text(message).textAlign(.leading)
            }
            if !DeviceRequirement.iPhone.isSatisfied {
                Spacer()
            }
            VHStack(DeviceRequirement.iPhone.isSatisfied ? .horizontal : .vertical) {
                Actions(actions: actions)
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(DesignSystem.largeCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.largeCornerRadius)
                .stroke(Color.labelTertiary, lineWidth: 1)
        )
    }
}

private struct Actions: View {
    let actions: [NewsBannerAction]
    
    var body: some View {
        ForEach(actions) { action in
            Button(action.title) { action.action() }
                .buttonStyle(action.style)
        }
    }
}
