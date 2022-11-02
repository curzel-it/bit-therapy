import DesignSystem
import OnWindow
import Schwifty
import SwiftUI

struct MainView: View {
    @StateObject var appState = AppState.global
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            Header()
            PageContents()
            Spacer(minLength: 0)
        }
        .frame(minWidth: 600)
        .frame(minHeight: 600)
        .foregroundColor(.label)
        .environmentObject(viewModel)
        .environmentObject(appState)
    }
}

class MainViewModel: ObservableObject {
    @Published public var selectedPage: AppPage = .home
}

enum AppPage: String, CaseIterable {
    case home
    case settings
    case about
}

extension AppPage: CustomStringConvertible, Tabbable {
    var description: String {
        switch self {
        case .home: return Lang.Page.home
        case .settings: return Lang.Page.settings
        case .about: return Lang.Page.about
        }
    }
}

private struct Header: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            TabSelector(
                selection: $viewModel.selectedPage,
                options: AppPage.allCases
            )
            JoinOurDiscord()
        }
    }
}

private struct PageContents: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        switch viewModel.selectedPage {
        case .home: Homepage()
        case .settings: SettingsView()
        case .about: AboutView()
        }
    }
}

private struct PageTitle: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        Text(viewModel.selectedPage.description)
            .textAlign(.center)
            .font(.largeTitle)
            .padding()
    }
}

private let discord = "https://discord.gg/MCdEgXKSH5"

private struct JoinOurDiscord: View {
    var body: some View {
        Image("discordLarge")
            .resizable()
            .frame(width: 99, height: 24)
            .cornerRadius(4)
            .padding(.trailing, .md)
            .onTapGesture {
                NSWorkspace.shared.open(urlString: discord)
            }
    }
}
