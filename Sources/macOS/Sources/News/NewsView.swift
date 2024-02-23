import Schwifty
import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        VStack(spacing: .md) {
            if viewModel.showStartAtLoginAlert {
                NewsBanner(
                    title: Lang.Settings.launchAtLogin,
                    message: Lang.Settings.launchAtLoginPromo,
                    actions: [
                        .init(title: Lang.no, style: .text, action: viewModel.disableLaunchAtLogin),
                        .init(title: Lang.yes, style: .regular, action: viewModel.enableLaunchAtLogin)
                    ]
                )
            }
            if viewModel.showCustomPetsAlert {
                NewsBanner(
                    title: Lang.Onboarding.customPetsTitle,
                    message: Lang.Onboarding.customPetsMessage,
                    actions: []
                )
            }
            if viewModel.showCybertruckAlert {
                NewsBanner(
                    title: Lang.Youtube.cybertruckTitle,
                    message: Lang.Youtube.cybertruckMessage,
                    actions: [
                        .init(title: Lang.Youtube.cybertruckAction, style: .regular) {
                            let url = URL(string: Lang.Youtube.cybertruckLink) ?? URL(string: Lang.Urls.youtube)
                            url?.visit()
                        }
                    ]
                )
            }
        }
        .padding(.bottom, viewModel.bottomPadding)
    }
}

private class NewsViewModel: ObservableObject {
    @Inject private var launchAtLogin: LaunchAtLoginUseCase
    @Inject private var speciesProvider: SpeciesProvider

    @Published var showStartAtLoginAlert: Bool = false
    @Published var showCybertruckAlert: Bool = false
    @Published var showCustomPetsAlert: Bool = false
    @Published var bottomPadding: Spacing = .zero

    @AppStorage("didShowLaunchAtLoginAlertxx") private var didShowLaunchAtLoginAlert = false
    @AppStorage("didShowCybertruckLaunchVideo") private var didShowCybertruckLaunchVideo = false
    @AppStorage("didShowCustomPetsAlert") private var didShowCustomPetsAlert = false

    init() {
        showStartAtLoginAlert = !didShowLaunchAtLoginAlert && launchAtLogin.isAvailable && !launchAtLogin.isEnabled
        if showStartAtLoginAlert {
            didShowLaunchAtLoginAlert = true
        }

        showCybertruckAlert = !didShowCybertruckLaunchVideo
        didShowCybertruckLaunchVideo = true

        showCustomPetsAlert = !didShowCustomPetsAlert
        didShowCustomPetsAlert = true

        bottomPadding = showStartAtLoginAlert || showCybertruckAlert || showCustomPetsAlert ? .xxl : .zero
    }

    func enableLaunchAtLogin() {
        showStartAtLoginAlert = false
        launchAtLogin.enable()
        withAnimation {
            showStartAtLoginAlert = false
        }
    }

    func disableLaunchAtLogin() {
        showStartAtLoginAlert = false
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
        .cornerRadius(DesignSystem.buttonsCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.buttonsCornerRadius)
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
