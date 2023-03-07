import Schwifty
import SwiftUI

struct MainScene: Scene {
    @StateObject var appState = AppState.global
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onboardingHandler()
                .preferredColorScheme(appState.preferredColorScheme())
                .environmentObject(appState)
        }
    }
}

private extension AppState {
    func preferredColorScheme() -> ColorScheme? {
        let backgroundName = background.lowercased()
        if backgroundName.contains("day") { return .light }
        if backgroundName.contains("night") { return .dark }
        return nil
    }
}

private struct ContentView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            Background()
            contents(of: viewModel.selectedPage)
            TabBar(
                selection: $viewModel.selectedPage,
                options: viewModel.options
            )
        }
        .environmentObject(viewModel)
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

private class MainViewModel: ObservableObject {
    @Published public var selectedPage: AppPage = .petSelection
    
    let options: [AppPage] = [.petSelection, .screensaver, .settings, .about]
}

private struct Background: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    private var overlayColor: Color {
        mainViewModel.selectedPage == .screensaver ? .clear : .background.opacity(0.2)
    }
        
    var body: some View {
        GeometryReader { geometry in
            Image(appState.background)
                .interpolation(.none)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width + geometry.safeAreaInsets.horizontal)
                .frame(height: geometry.size.height + geometry.safeAreaInsets.vertical)
                .edgesIgnoringSafeArea(.all)
                .overlay(overlayColor)
        }
    }
}
