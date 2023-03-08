import Combine
import Schwifty
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ContentViewModel()

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
        .preferredColorScheme(appState.preferredColorScheme())
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

private class ContentViewModel: ObservableObject {
    @Published var selectedPage: AppPage = .petSelection
    @Published var backgroundImage: String
    @Published var backgroundBlurRadius: CGFloat
    
    lazy var options: [AppPage] = {
        if DeviceRequirement.iOS.isSatisfied {
            return [.petSelection, .screensaver, .settings, .about]
        } else {
            return [.petSelection, .screensaver, .settings, .contributors, .about]
        }
    }()
    
    private var disposables = Set<AnyCancellable>()
    
    init() {
        selectedPage = .petSelection
        backgroundImage = AppState.global.background
        backgroundBlurRadius = 10
        bindBackground()
    }
    
    private func bindBackground() {
        AppState.global.$background
            .sink { [weak self] in self?.backgroundImage = $0 }
            .store(in: &disposables)
        
        $selectedPage
            .sink { [weak self] in self?.backgroundBlurRadius = $0 != .screensaver ? 10 : 0 }
            .store(in: &disposables)
    }
}

private struct Background: View {
    @EnvironmentObject private var viewModel: ContentViewModel
        
    var body: some View {
        GeometryReader { geometry in
            Image(viewModel.backgroundImage)
                .interpolation(.none)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width + geometry.safeAreaInsets.horizontal + 20)
                .frame(height: geometry.size.height + geometry.safeAreaInsets.vertical + 20)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: viewModel.backgroundBlurRadius)
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
