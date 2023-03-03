import Schwifty
import SwiftUI

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private struct ContentView: View {
    @StateObject var appState = AppState.global
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        TabView(selection: $viewModel.selectedPage) {
            ForEach(viewModel.options, id: \.self) { page in
                contents(of: page)
                    .tabItem {
                        Label(page.rawValue, systemImage: "gear")
                    }
                    .tag(page)
            }
        }
        .foregroundColor(.label)
        .environmentObject(viewModel)
        .environmentObject(appState)
    }
    
    @ViewBuilder private func contents(of page: AppPage) -> some View {
        switch page {
        case .about: AboutView()
        case .contributors: ContributorsView()
        case .home: PetsSelectionView()
        case .settings: SettingsView()
        case .none: EmptyView()
        }
    }
}

class MainViewModel: ObservableObject {
    @Published public var selectedPage: AppPage = .home
    
    let options: [AppPage] = [.home, .settings, .contributors, .about]
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

private struct JoinOurDiscord: View {
    var body: some View {
        Image("discordLarge")
            .resizable()
            .antialiased(true)
            .frame(width: 115, height: 28)
            .cornerRadius(DesignSystem.defaultCornerRadius)
            .padding(.trailing, .md)
            .onTapGesture { URL.visit(urlString: Lang.Urls.discord) }
    }
}
