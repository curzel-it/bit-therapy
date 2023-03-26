import Combine
import Schwifty
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appConfig: AppConfig
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Background()
            if !viewModel.isLoading {
                contents(of: viewModel.selectedPage)
                TabBar(viewModel: viewModel)
                BackToHomeButton()
            }
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
    @Inject private var species: SpeciesProvider
    @Inject private var theme: ThemeUseCase
    
    @Published var tabBarHidden: Bool = false
    @Published var isLoading: Bool = true
    @Published var backgroundBlurRadius: CGFloat
    @Published var backgroundImage: String = ""
    @Published var colorScheme: ColorScheme?
    @Published var selectedPage: AppPage = .petSelection
    
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
        backgroundBlurRadius = 10
        backgroundImage = appConfig.background
        bindTabBarHidden()
        bindBackground()
        bindColorScheme()
        bindLoading()
    }
    
    private func bindTabBarHidden() {
        $selectedPage
            .sink { [weak self] selection in
                withAnimation {
                    self?.tabBarHidden = selection == .screensaver
                }
            }
            .store(in: &disposables)
    }
    
    private func bindLoading() {
        species.all()
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                withAnimation {
                    self.isLoading = false
                }
            }
            .store(in: &disposables)
    }
    
    private func bindBackground() {
        appConfig.$background
            .sink { [weak self] in self?.backgroundImage = $0 }
            .store(in: &disposables)
        
        Publishers.CombineLatest($selectedPage, $isLoading)
            .sink { [weak self] selectedPage, isLoading in
                guard let self else { return }
                let shouldBlur = selectedPage != .screensaver && !isLoading
                self.backgroundBlurRadius = shouldBlur ? 10 : 0
            }
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

extension ContentViewModel: TabBarViewModel {
    // ...
}

private struct BackToHomeButton: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        if viewModel.tabBarHidden {
            Image(systemName: "pawprint")
                .font(.title)
                .onTapGesture {
                    withAnimation {
                        viewModel.selectedPage = .petSelection
                    }
                }
                .positioned(.leadingTop)
                .padding(.top, .md)
                .padding(.leading, .md)
        }
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
