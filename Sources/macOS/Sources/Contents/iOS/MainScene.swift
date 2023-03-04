import Schwifty
import SwiftUI

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onboardingHandler()
        }
    }
}

private struct ContentView: View {
    @StateObject var appState = AppState.global
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            contents(of: viewModel.selectedPage)            
            TabBar(
                selection: $viewModel.selectedPage,
                options: viewModel.options
            )
        }
        .environmentObject(viewModel)
        .environmentObject(appState)
    }
    
    private var shouldShowTabBar: Bool {
        viewModel.selectedPage != .screensaver
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
