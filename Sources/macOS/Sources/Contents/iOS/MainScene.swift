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
                    .tabItem { Label(page.description, systemImage: icon(for: page)) }
                    .tag(page)
            }
        }
        .foregroundColor(.label)
        .environmentObject(viewModel)
        .environmentObject(appState)
    }
    
    private func icon(for page: AppPage) -> String {
        switch page {
        case .about: return "info.circle"
        case .contributors: return "info.circle"
        case .petSelection: return "pawprint"
        case .screensaver: return "binoculars"
        case .settings: return "gearshape"
        case .none: return "questionmark.diamond"
        }
    }
    
    @ViewBuilder private func contents(of page: AppPage) -> some View {
        switch page {
        case .about: AboutView()
        case .contributors: ContributorsView()
        case .petSelection: PetsSelectionView()
        case .screensaver: ScreensaverView()
        case .settings: SettingsView()
        case .none: EmptyView()
        }
    }
}

class MainViewModel: ObservableObject {
    @Published public var selectedPage: AppPage = .petSelection
    
    let options: [AppPage] = [.petSelection, .screensaver, .settings, .about]
}
