import Combine
import Schwifty
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appConfig: AppConfig
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
        .preferredColorScheme(viewModel.colorScheme)
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
    @Inject private var appConfig: AppConfig
    @Inject private var theme: ThemeUseCase
    
    @Published var backgroundBlurRadius: CGFloat
    @Published var backgroundImage: String = ""
    @Published var colorScheme: ColorScheme?
    @Published var selectedPage: AppPage = .petSelection
    
    lazy var options: [AppPage] = {
        if DeviceRequirement.iOS.isSatisfied {
            return [.petSelection, .screensaver, .settings, .about]
        } else {
            return [.petSelection, .settings, .contributors, .about]
        }
    }()
    
    private var disposables = Set<AnyCancellable>()
    
    init() {
        selectedPage = .petSelection
        backgroundBlurRadius = 10
        backgroundImage = appConfig.background
        bindBackground()
        bindColorScheme()
    }
    
    private func bindBackground() {
        appConfig.$background
            .sink { [weak self] in self?.backgroundImage = $0 }
            .store(in: &disposables)
        
        $selectedPage
            .sink { [weak self] in self?.backgroundBlurRadius = $0 != .screensaver ? 10 : 0 }
            .store(in: &disposables)
    }
    
    private func bindColorScheme() {
        theme.theme()
            .sink { [weak self] theme in
                guard let self else { return }
                withAnimation {
                    self.colorScheme = theme.colorScheme
                }
            }
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
