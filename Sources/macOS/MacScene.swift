import DesignSystem
import LaunchAtLogin
import Schwifty
import SwiftUI
import Taku
import Tracking

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension MainScene {
    static func show() {
        showMainWindow()
        trackAppLaunched()
    }
    
    private static func showMainWindow() {
        let view = NSHostingView(rootView: ContentView())
        let window = NSWindow(
            contentRect: CGRect(x: 400, y: 200, width: 600, height: 600),
            styleMask: [.resizable, .closable, .titled],
            backing: .buffered,
            defer: false
        )
        window.title = "Desktop Pets"
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        window.show()
    }
    
    private static func trackAppLaunched() {
        let appState = AppState.global
        Tracking.didLaunchApp(
            gravityEnabled: appState.gravityEnabled,
            petSize: appState.petSize,
            launchAtLogin: LaunchAtLogin.isEnabled,
            selectedPets: appState.selectedPets
        )
    }
}

private struct ContentView: View {
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

extension AppPage: Tabbable {}

private struct Header: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel
    
    var options: [AppPage] = [.home, .settings, .about, .taku]
    
    var body: some View {
        HStack {
            TabSelector(selection: $viewModel.selectedPage, options: options)
            JoinOurDiscord()
        }
    }
}

private struct PageContents: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        switch viewModel.selectedPage {
        case .about: AboutView()
        case .home: PetsSelectionCoordinator.view()
        case .settings: SettingsView()
        case .taku: TakuView(token: "noTokensYet")
        case .none: EmptyView()
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

private struct JoinOurDiscord: View {
    var body: some View {
        Image("discordLarge")
            .resizable()
            .frame(width: 99, height: 24)
            .cornerRadius(4)
            .padding(.trailing, .md)
            .onTapGesture { URL.visit(urlString: Lang.Urls.discord) }
    }
}
